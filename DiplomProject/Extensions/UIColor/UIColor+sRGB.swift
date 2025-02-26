import UIKit

extension UIColor {
    var sRGB: UIColor {
        guard let components = cgColor.components else { return self }
        
        let r = components[0]
        let g = components.count > 1 ? components[1] : r
        let b = components.count > 2 ? components[2] : r
        let alpha = components.count > 3 ? components[3] : 1.0

        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}
