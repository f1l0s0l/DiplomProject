import UIKit

public extension NavigationBarTheme {
    static var monochrome: Self {
        NavigationBarTheme(
            background: UIColor.rgba(light: 0xF8BFD4FF, dark: 0xB23C42FF),
            title: UIColor.rgba(light: 0x4A4A4AFF, dark: 0xFFFFFFFF)
        )
    }
}