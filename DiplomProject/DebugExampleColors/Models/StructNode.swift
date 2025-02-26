import UIKit

enum StructNodeValue {
    case color(UIColor)
    case gradientColors([UIColor])
    
    var color: UIColor? {
        switch self {
        case .color(let color):
            return color
        case .gradientColors:
            return nil
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

    func insert(path: [String], value: StructNodeValue) {
        guard !path.isEmpty else { return }
        let key = path[0]
        
        if path.count == 1 {
            children[key] = StructNode(name: key, value: value)
        } else {
            if children[key] == nil {
                children[key] = StructNode(name: key)
            }
            children[key]!.insert(path: Array(path.dropFirst()), value: value)
        }
    }
}
