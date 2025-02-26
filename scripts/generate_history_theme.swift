#!/usr/bin/swift

import Foundation

// MARK: - Constants and Helpers

let indent = "    "
let reservedWords: Set<String> = ["default"]
let rootStructNodeNameSuffix = "Theme"
let bubblesRootStructName = "Bubbles\(rootStructNodeNameSuffix)"
let bubblesChildRootStuctName = "BubbleColors"

let codeGenString = "CodeGen"
let codeGenThemeTypeString = "\(codeGenString)ThemeType"

let parseHistoryColorsScriptFilePath = "./scripts/parse_history_colors.swift"
let codeGenInOMUIConstantsDirPath = "./DiplomProject/ThemeProvider/\(codeGenString)/"
let appearanceChatJSONFilePath = "./scripts/CurrentJSON/appearance.json"

private func pascalCase(_ text: String) -> String {
    text
        .split(separator: " ")
        .map(capitalizeFirstLetter)
        .joined()
}

func camelCase(_ text: String) -> String {
    guard text.count > 1 else {
        return text
    }
    let camelCaseText = pascalCase(text)
    return camelCaseText.prefix(1).lowercased() + camelCaseText.dropFirst()
}

func capitalizeFirstLetter(_ text: some StringProtocol) -> String {
    return text.prefix(1).uppercased() + text.dropFirst()
}

enum ANSI: String {
    case green = "\u{001B}[32m"
    case yellow = "\u{001B}[33m"
    case red = "\u{001B}[31m"
    case stop = "\u{001B}[0m"
}

func color(_ text: String, to code: ANSI) -> String {
    "\(code.rawValue)\(text)\(ANSI.stop.rawValue)"
}

enum Errors: Error {
    case parseThemeError(errorString: String)
    case themeNotFound(themeName: String )
    case invalidColorName(colorName: String)

    var description: String {
        switch self {
        case .parseThemeError(let errorString):
            color("Error from \(parseHistoryColorsScriptFilePath):\n\(errorString)", to: .red)
        case .themeNotFound(let themeName):
            color("Not have rootStructs for \(themeName) theme", to: .red)
        case .invalidColorName(let colorName):
            color("Color token", to: .red) + color(colorName, to: .yellow) + color("have value and child structs. Namespace conflict!", to: .red)
        }
    }
}

// MARK: - Parsing JSON

struct Theme: Codable {
    let themeName: String
    let colors: [ThemeColor]
}

struct ThemeColor: Codable {
    let name: String
    let lightValue: String
    let darkValue: String
}

func parseThemes(jsonFilePath: String) throws -> [Theme] {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
    process.arguments = [parseHistoryColorsScriptFilePath, jsonFilePath]

    let outputPipe = Pipe()
    let errorPipe = Pipe()
    process.standardOutput = outputPipe
    process.standardError = errorPipe

    try process.run()
    process.waitUntilExit()

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

    if let errorString = String(data: errorData, encoding: .utf8), errorString != "" {
        if process.terminationStatus == 0 {
            let wrongText = color("Not a critical error:\n\(errorString)", to: .yellow)
            print(wrongText)
        } else {
            throw Errors.parseThemeError(errorString: errorString)
        }
    }
    return try JSONDecoder().decode([Theme].self, from: outputData)
}




// MARK: - StructNode

struct DynamicColor {
    let light: String
    let dark: String

    var valueString: String {
        func convertToRGBA(_ hexString: String) -> String {
            let hex = hexString.replacingOccurrences(of: "#", with: "")
            let hexRGBA = hex.count > 6 ? hex : "\(hex)ff"
            return "0x\(hexRGBA.uppercased())"
        }
        return "UIColor.rgba(light: \(convertToRGBA(light)), dark: \(convertToRGBA(dark)))"
    }
}

enum StructNodeValue {
    case color(DynamicColor)
    case gradientColors([DynamicColor])

    var color: DynamicColor? {
        switch self {
        case .color(let color):
            return color
        case .gradientColors:
            return nil
        }
    }

    var typeString: String {
        switch self {
        case .color:
            "UIColor"
        case .gradientColors:
            "[UIColor]"
        }
    }

    func valueString(internalLevel: Int = 0) -> String {
        switch self {
        case .color(let color):
            return color.valueString
        case .gradientColors(let colors):
            let levelIndent = String(repeating: indent, count: internalLevel)
            let nextIndent = String(repeating: indent, count: internalLevel + 1)

            var result = "[\n\(nextIndent)"
            result += colors.map(\.valueString).joined(separator: ",\n\(nextIndent)")
            result += "\n\(levelIndent)]"
            return result
        }
    }
}

final class StructNode {
    let name: String
    var children: [String: StructNode]
    var value: StructNodeValue?

    init(name: String, children: [String: StructNode] = [:], value: StructNodeValue? = nil) {
        self.name = name
        self.children = children
        self.value = value
    }

    func insert(path: [String], value: StructNodeValue) throws {
        guard !path.isEmpty else { return }
        let key = path[0]

        if path.count == 1 {
            if children[key] != nil {
                throw Errors.invalidColorName(colorName: key)
            }
            children[key] = StructNode(name: key, value: value)
        } else {
            if children[key] == nil {
                children[key] = StructNode(name: key)
            }
            try children[key]!.insert(path: Array(path.dropFirst()), value: value)
        }
    }

    func checkAndAddGradient() {
        for key in children.keys {
            if key.lowercased().contains("step") {
                let stepColors = children.values
                    .filter { $0.name.lowercased().contains("step") }
                    .sorted { $0.name < $1.name }
                    .compactMap(\.value?.color)

                if !stepColors.isEmpty {
                    children["GradientColors"] = StructNode(name: "GradientColors", value: .gradientColors(stepColors))
                }
            }
        }

        for child in children.values {
            child.checkAndAddGradient()
        }
    }
}

// MARK: - Prepare CodeGen directories

func prepareCodeGenDirs() throws {
    try prepareCodeGenDir(pathToDir: codeGenInOMUIConstantsDirPath)
}

func prepareCodeGenDir(pathToDir: String) throws {
    let fileManager = FileManager.default
    let directoryURL = URL(fileURLWithPath: pathToDir)

    var isDirectory: ObjCBool = false
    if fileManager.fileExists(atPath: pathToDir, isDirectory: &isDirectory), isDirectory.boolValue {
        try fileManager.removeItem(at: directoryURL)
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
    } else {
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
    }
}

// MARK: - Create StructNodes

func createStructNodes(for themes: [Theme]) throws -> [String: [StructNode]] {
    var rootStructNodesDict: [String: [StructNode]] = [:]
    for theme in themes {
        var rootStructs: [StructNode] = []

        for color in theme.colors {
            let path = color.name
                .replacingOccurrences(of: " ", with: "")
                .components(separatedBy: "/")

            guard let root = path.first else { continue }

            if let rootNode = rootStructs.first(where: { $0.name == root }) {
                try rootNode.insert(path: Array(path.dropFirst()), value: .color(DynamicColor(light: color.lightValue, dark: color.darkValue)))
            } else {
                let root = StructNode(name: root)
                try root.insert(path: Array(path.dropFirst()), value: .color(DynamicColor(light: color.lightValue, dark: color.darkValue)))
                rootStructs.append(root)
            }
        }

        rootStructs.forEach { $0.checkAndAddGradient() }
        rootStructs = rootStructs.map {
            StructNode(name: "\($0.name)\(rootStructNodeNameSuffix)", children: $0.children, value: nil)
        }
        rootStructNodesDict[theme.themeName] = rootStructs
    }
    return rootStructNodesDict
}


// MARK: - Structure Declarations

extension StructNode {
    func generateStructDeclaration(internalLevel: Int = 0) -> String {
        let levelIndent = String(repeating: indent, count: internalLevel)
        let nextIndent = String(repeating: indent, count: internalLevel + 1)

        var properties: [String] = []
        var subStructs: [String] = []

        let sortedChildren = children.sorted { $0.key < $1.key }
        for (key, child) in sortedChildren {
            let propertyName = reservedWords.contains(key.lowercased()) ? "`\(camelCase(key))`" : camelCase(key)
            let typeName: String

            if let value = child.value {
                typeName = value.typeString
            } else {
                typeName = capitalizeFirstLetter(key)
                subStructs.append(child.generateStructDeclaration(internalLevel: internalLevel + 1))
            }
            properties.append("public let \(propertyName): \(typeName)")
        }

        let propertiesString = properties.isEmpty ? "" : properties.joined(separator: "\n\(nextIndent)")
        let subStructsString = subStructs.isEmpty ? "" : "\n\n\(subStructs.joined(separator: "\n\n"))"

        return """
        \(levelIndent)public struct \(name) {
        \(nextIndent)\(propertiesString)\(subStructsString)
        \(levelIndent)}
        """
    }

    func generateStructDeclarationForBubbles(internalLevel: Int = 0) -> String {
        let outgoingNode = children["Outgoing"]!
        let bubbleColorsNode = StructNode(name: bubblesChildRootStuctName, children: outgoingNode.children, value: nil)

        let bodyString = bubbleColorsNode.generateStructDeclaration(internalLevel: internalLevel + 1)

        return """
        public struct \(name) {
            public let incoming: \(bubblesChildRootStuctName)
            public let outgoing: \(bubblesChildRootStuctName)
        
        \(bodyString)
        }
        """
    }
}

func generateStructDeclarations(rootStructs: [StructNode]) throws {
    let fileManager = FileManager.default
    let codeGenDirectoryURL = URL(fileURLWithPath: codeGenInOMUIConstantsDirPath)

    for root in rootStructs {
        let fileContent: String

        if root.name == bubblesRootStructName, root.children["Outgoing"] != nil {
            fileContent = root.generateStructDeclarationForBubbles()
        } else {
            fileContent = root.generateStructDeclaration()
        }
        
        let finalContent = "import UIKit\n\n\(fileContent)"

        let structDirURL = codeGenDirectoryURL.appending(path: root.name)
        try fileManager.createDirectory(at: structDirURL, withIntermediateDirectories: true, attributes: nil)

        let structFilePath = "\(structDirURL.path())/\(root.name).swift"
        try finalContent.write(toFile: structFilePath, atomically: true, encoding: .utf8)
    }
}


// MARK: - Structure Initializations

extension StructNode {
    func generateStructInitialization(internalLevel: Int, path: [String] = []) -> String {
        let lastPath = path + [capitalizeFirstLetter(name)]
            .map { $0 == "Incoming" || $0 == "Outgoing" ? bubblesChildRootStuctName : $0 }

        let lastPathString = lastPath.joined(separator: ".")

        var properties: [String] = []
        let levelIndent = String(repeating: indent, count: internalLevel)

        let sortedChildren = children.sorted { $0.key < $1.key }
        for (key, child) in sortedChildren {
            if let value = child.value {
                properties.append("\(levelIndent)\(camelCase(key)): \(value.valueString(internalLevel: internalLevel))")
            } else {
                properties.append("\(levelIndent)\(camelCase(key)): \(child.generateStructInitialization(internalLevel: internalLevel + 1, path: lastPath))")
            }
        }

        return """
        \(lastPathString)(
        \(properties.joined(separator: ",\n"))
        \(String(repeating: indent, count: internalLevel - 1)))
        """
    }
}

func generateStructInitialization(for themeName: String, structNode: StructNode) -> String {
    return """
    import UIKit
    
    public extension \(structNode.name) {
        static var \(camelCase(themeName)): Self {
            \(structNode.generateStructInitialization(internalLevel: 3, path: []))
        }
    }
    """
}

func generateStructDefaultInitialization(rootStructNodesDict: [String: [StructNode]]) throws {
    for (themeName, rootStructs) in rootStructNodesDict {
        for root in rootStructs {
            let fileContent = generateStructInitialization(for: themeName, structNode: root)

            let filePath = "\(codeGenInOMUIConstantsDirPath)/\(root.name)/\(root.name)+\(themeName).swift"
            try fileContent.write(toFile: filePath, atomically: true, encoding: .utf8)
        }
    }
}

// MARK: - CodeGenThemeType

func generateCodeGenThemeType(rootStructNodesDict: [String: [StructNode]]) throws {
    let themeNames = rootStructNodesDict.keys.sorted()
        .map { "case \(camelCase($0))" }
        .joined(separator: "\n\(indent)")

    let fileContent = """
    public enum \(codeGenThemeTypeString): Int, CaseIterable {
        \(themeNames)
    }
    
    """

    let filePath = "\(codeGenInOMUIConstantsDirPath)\(codeGenThemeTypeString).swift"
    try fileContent.write(toFile: filePath, atomically: true, encoding: .utf8)
}

// MARK: - Main

func main() throws {
    let themes = try parseThemes(jsonFilePath: appearanceChatJSONFilePath)
    let rootStructNodesDict = try createStructNodes(for: themes)

    guard let rootStructs = rootStructNodesDict[themes.first!.themeName] else {
        throw Errors.themeNotFound(themeName: themes.first!.themeName)
    }

    try prepareCodeGenDirs()

    try generateStructDeclarations(rootStructs: rootStructs)
    try generateStructDefaultInitialization(rootStructNodesDict: rootStructNodesDict)
    try generateCodeGenThemeType(rootStructNodesDict: rootStructNodesDict)
}

do {
    try main()
    print(color("Success", to: .green))
} catch let error as Errors {
    print(error.description)
} catch {
    print(error)
}
