import UIKit

public extension TabBarTheme {
    static var bumble: Self {
        TabBarTheme(
            background: UIColor.rgba(light: 0xFFFFFFFF, dark: 0x0C0D0EFF),
            icon: TabBarTheme.Icon(
                primary: UIColor.rgba(light: 0xF57C00FF, dark: 0xFFA726FF),
                secondary: UIColor.rgba(light: 0x8E8E93FF, dark: 0x505050FF)
            )
        )
    }
}