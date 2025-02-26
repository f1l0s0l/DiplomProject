import UIKit

extension CommonTheme {
    static var bumble: CommonTheme {
        CommonTheme(
            text: Text(
                action: UIColor(light: 0x007AFF, lightAlpha: 1, dark: 0x0A84FF, darkAlpha: 1),
                negative: UIColor(light: 0xFF3B30, lightAlpha: 1, dark: 0xFF453A, darkAlpha: 1),
                primary: UIColor(light: 0x000000, lightAlpha: 1, dark: 0xFFFFFF, darkAlpha: 1),
                secondary: UIColor(light: 0x3C3C43, lightAlpha: 0.6, dark: 0xEBEBF5, darkAlpha: 0.6),
                tertiary: UIColor(light: 0x3C3C43, lightAlpha: 0.3, dark: 0xEBEBF5, darkAlpha: 0.3),
                name: UIColor(light: 0xFFD60A, lightAlpha: 1, dark: 0xFF9F0A, darkAlpha: 1),
                contrast: UIColor(light: 0x000000, lightAlpha: 1, dark: 0xFFFFFF, darkAlpha: 1)
            ),
            background: Background(
                themed: UIColor(light: 0xFFFDE7, lightAlpha: 1, dark: 0x2C2C2C, darkAlpha: 1),
                surface: UIColor(light: 0xFFFFFF, lightAlpha: 1, dark: 0x1C1C1E, darkAlpha: 1),
                grouped: UIColor(light: 0xF2F2F7, lightAlpha: 1, dark: 0x2C2C2E, darkAlpha: 1)
            ),
            icon: Icon(
                themed: UIColor(light: 0xFFD60A, lightAlpha: 1, dark: 0xFF9F0A, darkAlpha: 1),
                secondary: UIColor(light: 0x8E8E93, lightAlpha: 1, dark: 0x505050, darkAlpha: 1),
                contrast: UIColor(light: 0x000000, lightAlpha: 1, dark: 0xFFFFFF, darkAlpha: 1),
                negative: UIColor(light: 0xFF3B30, lightAlpha: 1, dark: 0xFF453A, darkAlpha: 1)
            ),
            stroke: Stroke(
                primary: UIColor(light: 0x0C0D0E, lightAlpha: 0.75, dark: 0xFFFFFF, darkAlpha: 0.75),
                secondary: UIColor(light: 0x0C0D0E, lightAlpha: 0.4, dark: 0xFFFFFF, darkAlpha: 0.4)
            )
        )
    }
    
    static var pink: CommonTheme {
        CommonTheme(
            text: Text(
                action: UIColor(light: 0xFF007F, lightAlpha: 1, dark: 0xFF5A8D, darkAlpha: 1),
                negative: UIColor(light: 0xFF3B30, lightAlpha: 1, dark: 0xFF453A, darkAlpha: 1),
                primary: UIColor(light: 0x4A4A4A, lightAlpha: 1, dark: 0xFFFFFF, darkAlpha: 1),
                secondary: UIColor(light: 0xD1A8C0, lightAlpha: 0.8, dark: 0xE6A3C7, darkAlpha: 0.8),
                tertiary: UIColor(light: 0xF5A7C5, lightAlpha: 0.6, dark: 0xE0A1C1, darkAlpha: 0.6),
                name: UIColor(light: 0xFF9AA2, lightAlpha: 1, dark: 0xFF8DAA, darkAlpha: 1),
                contrast: UIColor(light: 0x000000, lightAlpha: 1, dark: 0xFFFFFF, darkAlpha: 1)
            ),
            background: Background(
                themed: UIColor(light: 0xFFE1E1, lightAlpha: 1, dark: 0x3B0D0D, darkAlpha: 1),
                surface: UIColor(light: 0xFFCCE5, lightAlpha: 1, dark: 0x2F0D0D, darkAlpha: 1),
                grouped: UIColor(light: 0xF4D1D1, lightAlpha: 1, dark: 0x3C2C2C, darkAlpha: 1)
            ),
            icon: Icon(
                themed: UIColor(light: 0xFF8D92, lightAlpha: 1, dark: 0xFF4F6C, darkAlpha: 1),
                secondary: UIColor(light: 0xFFB3C1, lightAlpha: 1, dark: 0xF1A0B7, darkAlpha: 1),
                contrast: UIColor(light: 0x000000, lightAlpha: 1, dark: 0xFFFFFF, darkAlpha: 1),
                negative: UIColor(light: 0xFF3B30, lightAlpha: 1, dark: 0xFF453A, darkAlpha: 1)
            ),
            stroke: Stroke(
                primary: UIColor(light: 0xF0C1D6, lightAlpha: 0.8, dark: 0xFAD1E0, darkAlpha: 0.8),
                secondary: UIColor(light: 0xF6D3D6, lightAlpha: 0.6, dark: 0xB9A0A5, darkAlpha: 0.6)
            )
        )
    }
}
