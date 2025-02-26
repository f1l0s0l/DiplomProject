import UIKit

public extension TabBarTheme {
    static var monochrome: Self {
        TabBarTheme(
            background: UIColor.rgba(light: 0xFFCCE5FF, dark: 0x3F1D21FF),
            icon: TabBarTheme.Icon(
                primary: UIColor.rgba(light: 0xFF6F91FF, dark: 0xFF4D6FFF),
                secondary: UIColor.rgba(light: 0xFFB3C1FF, dark: 0xF1A0B7FF)
            )
        )
    }
}