import UIKit

extension UIColor {
    static func rgba(light: UInt32, dark: UInt32) -> UIColor {
        UIColor(light: UIColor.rgba(hex: light), dark: UIColor.rgba(hex: dark))
    }
    
    static func rgba(hex: UInt32) -> UIColor {
        let r = CGFloat((hex & 0xFF000000) >> 24) / 255.0
        let g = CGFloat((hex & 0x00FF0000) >> 16) / 255.0
        let b = CGFloat((hex & 0x0000FF00) >> 8) / 255.0
        let a = CGFloat(hex & 0x000000FF) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    convenience init(light: UInt32, lightAlpha: CGFloat, dark: UInt32, darkAlpha: CGFloat) {
        self.init(light: UIColor(hex: light, alpha: lightAlpha), dark: UIColor(hex: dark, alpha: darkAlpha))
    }
    
    convenience init(hex: UInt32, alpha: CGFloat) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
