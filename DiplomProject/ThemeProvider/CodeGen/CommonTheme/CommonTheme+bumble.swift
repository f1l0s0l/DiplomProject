import UIKit

public extension CommonTheme {
    static var bumble: Self {
        CommonTheme(
            background: CommonTheme.Background(
                grouped: UIColor.rgba(light: 0xF2F2F7FF, dark: 0x2C2C2EFF),
                surface: UIColor.rgba(light: 0xFFFFFFFF, dark: 0x1C1C1EFF),
                themed: UIColor.rgba(light: 0xFFFDE7FF, dark: 0x2C2C2CFF)
            ),
            icon: CommonTheme.Icon(
                contrast: UIColor.rgba(light: 0x000000FF, dark: 0xFFFFFFFF),
                negative: UIColor.rgba(light: 0xFF3B30FF, dark: 0xFF453AFF),
                secondary: UIColor.rgba(light: 0x8E8E93FF, dark: 0x505050FF),
                themed: UIColor.rgba(light: 0xFFD60AFF, dark: 0xFF9F0AFF)
            ),
            stroke: CommonTheme.Stroke(
                primary: UIColor.rgba(light: 0x0C0D0EBF, dark: 0xFFFFFFBF),
                secondary: UIColor.rgba(light: 0x0C0D0E66, dark: 0xFFFFFF66)
            ),
            text: CommonTheme.Text(
                action: UIColor.rgba(light: 0x007AFFFF, dark: 0x0A84FFFF),
                contrast: UIColor.rgba(light: 0x000000FF, dark: 0xFFFFFFFF),
                name: UIColor.rgba(light: 0xFFD60AFF, dark: 0xFF9F0AFF),
                negative: UIColor.rgba(light: 0xFF3B30FF, dark: 0xFF453AFF),
                primary: UIColor.rgba(light: 0x000000FF, dark: 0xFFFFFFFF),
                secondary: UIColor.rgba(light: 0x3C3C4399, dark: 0xEBEBF599),
                tertiary: UIColor.rgba(light: 0x3C3C434D, dark: 0xEBEBF54D)
            )
        )
    }
}