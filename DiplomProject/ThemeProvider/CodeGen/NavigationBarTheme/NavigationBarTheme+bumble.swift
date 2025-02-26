import UIKit

extension NavigationBarTheme {
    static var bumble: NavigationBarTheme {
        NavigationBarTheme(
            background: UIColor(light: 0xFFFFFF, lightAlpha: 1, dark: 0x1C1C1E, darkAlpha: 1),
            title: UIColor(light: 0x000000, lightAlpha: 1, dark: 0xFFFFFF, darkAlpha: 1)
        )
    }
    
    
    static var pink: NavigationBarTheme {
        NavigationBarTheme(
            background: UIColor(light: 0xF8BFD4, lightAlpha: 1, dark: 0xB23C42, darkAlpha: 1),
            title: UIColor(light: 0x4A4A4A, lightAlpha: 1, dark: 0xFFFFFF, darkAlpha: 1)
        )
    }
}
