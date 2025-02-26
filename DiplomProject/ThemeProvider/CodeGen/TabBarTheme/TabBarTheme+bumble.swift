import UIKit

extension TabBarTheme {
    static var bumble: TabBarTheme {
        TabBarTheme(
            background: UIColor(light: 0xFFFFFF, lightAlpha: 1, dark: 0x0C0D0E, darkAlpha: 1),
            icon: Icon(
                primary: UIColor(light: 0xF57C00, lightAlpha: 1, dark: 0xFFA726, darkAlpha: 1),
                secondary: UIColor(light: 0x8E8E93, lightAlpha: 1, dark: 0x505050, darkAlpha: 1)
            )
        )
    }
    
    
    static var pink: TabBarTheme {
        TabBarTheme(
            background: UIColor(light: 0xFFCCE5, lightAlpha: 1, dark: 0x3F1D21, darkAlpha: 1),
            icon: Icon(
                primary: UIColor(light: 0xFF6F91, lightAlpha: 1, dark: 0xFF4D6F, darkAlpha: 1),
                secondary: UIColor(light: 0xFFB3C1, lightAlpha: 1, dark: 0xF1A0B7, darkAlpha: 1)
            )
        )
    }
}
