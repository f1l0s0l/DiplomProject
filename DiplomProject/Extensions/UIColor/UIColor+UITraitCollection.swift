import UIKit

extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: dark
            case .light, .unspecified: light
            @unknown default: light
            }
        }
    }
}
