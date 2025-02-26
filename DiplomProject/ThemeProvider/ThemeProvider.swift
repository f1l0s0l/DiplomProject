import UIKit

final class ThemeProvider {
    
    static let didChangeThemeNotification = Notification.Name("ThemeDidChange")
    
    private(set) var commonTheme: CommonTheme
    private(set) var navigationBarTheme: NavigationBarTheme
    private(set) var tabBarTheme: TabBarTheme
    
    init(themeType: CodeGenThemeType) {
        commonTheme = CommonTheme(themeType: themeType)
        navigationBarTheme = NavigationBarTheme(themeType: themeType)
        tabBarTheme = TabBarTheme(themeType: themeType)
    }
    
    func update(themeType: CodeGenThemeType) {
        commonTheme = CommonTheme(themeType: themeType)
        navigationBarTheme = NavigationBarTheme(themeType: themeType)
        tabBarTheme = TabBarTheme(themeType: themeType)
        
        NotificationCenter.default.post(name: ThemeProvider.didChangeThemeNotification, object: nil)
    }
}
