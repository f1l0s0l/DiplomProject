#!/usr/bin/swift

import Foundation

// MARK: - Constants and Helpers

private let colorNameSuffixLightMode = " · Light Mode"
private let colorNameSuffixDarkMode = " · Dark Mode"


enum Errors: Error {
    case invalidJSONFilePath
    case invalidJSONFormat
    case invalidJSONKeyOrTypeValue([String])
    case themeColorNotFound(themeName: String, colorName: String)
    case incorrectThemeEncode
    case invalidArgumentsCount(Int)
    case notThemes

    var description: String {
        switch self {
        case .invalidJSONFilePath:
            "Invalid path to JSON file"
        case .invalidJSONFormat:
            "Invalid JSON format"
        case .invalidJSONKeyOrTypeValue(let invalidKeys):
            "Invalid JSON keys or type values. Keys: \(invalidKeys)"
        case .themeColorNotFound(let themeName, let colorName):
            "Missing value for color \(colorName) in theme \(themeName)"
        case .incorrectThemeEncode:
            "Incorrect encoding of the theme"
        case .invalidArgumentsCount(let count):
            "Invalid number of arguments: \(count)"
        case .notThemes:
            "Not themes"
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

func validateJSONFilePath(path: String) throws {
    let fileManager = FileManager.default
    var isDirectory: ObjCBool = false

    if fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
        if isDirectory.boolValue {
            throw Errors.invalidJSONFilePath
        }
    } else {
        throw Errors.invalidJSONFilePath
    }
}

func loadJSONFile(filePath: String) throws -> Data? {
    try validateJSONFilePath(path: filePath)

    let fileURL = URL(fileURLWithPath: filePath)
    return try Data(contentsOf: fileURL)

}

func jsonDataToDictionary(_ jsonData: Data) throws -> [String: Any]? {
    if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]], jsonArray.count == 1 {
        return jsonArray.first
    } else {
        throw Errors.invalidJSONFormat
    }
}


func parseThemes(jsonFilePath: String) throws -> [Theme] {
    guard let jsonData = try loadJSONFile(filePath: jsonFilePath),
          let jsonDict = try jsonDataToDictionary(jsonData),
          let values = jsonDict["values"] as? [[String: Any]] else {
        throw Errors.invalidJSONKeyOrTypeValue(["values"])
    }

    var themeDict: [String: [String: String]] = [:]

    for value in values {
        guard let mode = value["mode"] as? [String: Any],
              let themeNameFull = mode["name"] as? String,
              let colors = value["color"] as? [[String: Any]] else {
            throw Errors.invalidJSONKeyOrTypeValue(["mode", "name", "color"])
        }

        let themeNameBase = themeNameFull
            .replacingOccurrences(of: colorNameSuffixLightMode, with: "")
            .replacingOccurrences(of: colorNameSuffixDarkMode, with: "")

        for color in colors {
            if let colorName = color["name"] as? String, let colorValue = color["value"] as? String {
                if themeNameFull.contains(colorNameSuffixLightMode) {
                    themeDict[themeNameBase, default: [:]]["\(colorName)\(colorNameSuffixLightMode)"] = colorValue
                } else if themeNameFull.contains(colorNameSuffixDarkMode) {
                    themeDict[themeNameBase, default: [:]]["\(colorName)\(colorNameSuffixDarkMode)"] = colorValue
                }
            }
        }
    }

    var themes: [Theme] = []

    for (themeName, colors) in themeDict {
        var themeColors: [ThemeColor] = []

        for colorName in colors.keys {
            guard !colorName.contains(colorNameSuffixDarkMode) else { continue }
            let baseColorName = colorName.replacingOccurrences(of: colorNameSuffixLightMode, with: "")

            guard let lightValue = colors["\(baseColorName)\(colorNameSuffixLightMode)"], let darkValue = colors["\(baseColorName)\(colorNameSuffixDarkMode)"] else {
                throw Errors.themeColorNotFound(themeName: themeName, colorName: baseColorName)
            }

            themeColors.append(ThemeColor(name: baseColorName, lightValue: lightValue, darkValue: darkValue))
        }
        themes.append(Theme(themeName: themeName, colors: themeColors))
    }
    return themes
}

func decodeThemes(themes: [Theme]) throws -> String {
    let data = try JSONEncoder().encode(themes)
    if let jsonString = String(data: data, encoding: .utf8) {
        return jsonString
    } else {
        throw Errors.incorrectThemeEncode
    }
}

func main() throws {
    guard CommandLine.arguments.count == 2 else {
        throw Errors.invalidArgumentsCount(CommandLine.arguments.count)
    }
    let jsonFilePath = CommandLine.arguments[1]

    let themes = try parseThemes(jsonFilePath: jsonFilePath)

    guard themes.count > 0 else {
        throw Errors.notThemes
    }

    let jsonString = try decodeThemes(themes: themes)

    print(jsonString)
}

do {
    try main()
    exit(0)
} catch let error as Errors {
    FileHandle.standardError.write(error.description.data(using: .utf8)!)
    exit(10)
} catch {
    FileHandle.standardError.write("\(error)".data(using: .utf8)!)
    exit(10)
}
