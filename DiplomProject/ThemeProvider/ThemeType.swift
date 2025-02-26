enum ThemeType: Int, CaseIterable {
    case bumble
    case pink
    case monochrome
}

extension CommonTheme {
    init(themeType: ThemeType) {
        switch themeType {
        case .bumble:
            self = .bumble
        case .pink:
            self = .pink
        case .monochrome:
            self = .monochrome
        }
    }
}

extension NavigationBarTheme {
    init(themeType: ThemeType) {
        switch themeType {
        case .bumble:
            self = .bumble
        case .pink:
            self = .pink
        case .monochrome:
            self = .monochrome
        }
    }
}
extension TabBarTheme {
    init(themeType: ThemeType) {
        switch themeType {
        case .bumble:
            self = .bumble
        case .pink:
            self = .pink
        case .monochrome:
            self = .monochrome
        }
    }
}
