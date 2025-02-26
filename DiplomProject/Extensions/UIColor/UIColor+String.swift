import UIKit

extension UIColor {
    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        
        guard self.getRed(&r, green: &g, blue: &b, alpha: nil) else { return "#FFFFFF" }
        
        let red = lroundf(Float(r * 255))
        let green = lroundf(Float(g * 255))
        let blue = lroundf(Float(b * 255))
        
        return String(format: "%02X%02X%02X", red, green, blue)
    }
}
