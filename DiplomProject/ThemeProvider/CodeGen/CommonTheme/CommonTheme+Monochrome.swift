import UIKit

public extension CommonTheme {
    static var monochrome: Self {
        CommonTheme(
            background: CommonTheme.Background(
                grouped: UIColor.rgba(light: 0xF4D1D1FF, dark: 0x3C2C2CFF),
                surface: UIColor.rgba(light: 0xFFCCE5FF, dark: 0x2F0D0DFF),
                themed: UIColor.rgba(light: 0xFFE1E1FF, dark: 0x3B0D0DFF)
            ),
            icon: CommonTheme.Icon(
                contrast: UIColor.rgba(light: 0x000000FF, dark: 0xFFFFFFFF),
                negative: UIColor.rgba(light: 0xFF3B30FF, dark: 0xFF453AFF),
                secondary: UIColor.rgba(light: 0xFFB3C1FF, dark: 0xF1A0B7FF),
                themed: UIColor.rgba(light: 0xFF8D92FF, dark: 0xFF4F6CFF)
            ),
            stroke: CommonTheme.Stroke(
                primary: UIColor.rgba(light: 0xF0C1D6CC, dark: 0xFAD1E0CC),
                secondary: UIColor.rgba(light: 0xF6D3D699, dark: 0xB9A0A599)
            ),
            text: CommonTheme.Text(
                action: UIColor.rgba(light: 0xFF007FFF, dark: 0xFF5A8DFF),
                contrast: UIColor.rgba(light: 0x000000FF, dark: 0xFFFFFFFF),
                name: UIColor.rgba(light: 0xFF9AA2FF, dark: 0xFF8DAAFF),
                negative: UIColor.rgba(light: 0xFF3B30FF, dark: 0xFF453AFF),
                primary: UIColor.rgba(light: 0x4A4A4AFF, dark: 0xFFFFFFFF),
                secondary: UIColor.rgba(light: 0xD1A8C0CC, dark: 0xE6A3C7CC),
                tertiary: UIColor.rgba(light: 0xF5A7C599, dark: 0xE0A1C199)
            )
        )
    }
}