import Foundation

extension String {
    var capitalizedFirstChar: String {
        "\(prefix(1).uppercased())\(dropFirst())"
    }
    
    var splitCamelCase: String {
        splitUppercase().map(\.capitalizedFirstChar).joined(separator: " ")
    }
    
    private func splitUppercase() -> [String] {
        let regex = try! NSRegularExpression(pattern: "[A-Z]", options: [])
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: utf16.count))
        
        var result: [String] = []
        var lastIndex = startIndex
        
        for match in matches {
            let range = Range(match.range, in: self)!
            if lastIndex < range.lowerBound {
                result.append(String(self[lastIndex..<range.lowerBound]))
            }
            lastIndex = range.lowerBound
        }
        
        if lastIndex < endIndex {
            result.append(String(self[lastIndex...]))
        }
        
        return result
    }
}
