import UIKit

extension StructNode {
    static func convertToStructNode<T>(_ object: T, name: String? = nil) -> StructNode {
        let mirror = Mirror(reflecting: object)
        let nameNode = name ?? String(describing: mirror.subjectType)
        let node = StructNode(name: nameNode)
        
        for child in mirror.children {
            guard let key = child.label else { continue }
            
            if let value = child.value as? UIColor {
                node.children[key] = StructNode(name: key, value: .color(value))
            } else if let value = child.value as? [UIColor] {
                node.children[key] = StructNode(name: key, value: .gradientColors(value))
            } else {
                let childNode = convertToStructNode(child.value, name: key)
                node.children[key] = childNode
            }
        }
        return node
    }
}
