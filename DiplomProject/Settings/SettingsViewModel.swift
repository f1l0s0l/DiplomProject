final class SettingsViewModel {
    
    // MARK: - Public properties
    
    let user: User
    let themeProvider: ThemeProvider
    
    // MARK: - Private properties
    
    private weak var coordinator: SettingsCoordinatorProtocol?
    
    // MARK: - Lifecycles
    
    init(coordinator: SettingsCoordinatorProtocol?, user: User, themeProvider: ThemeProvider) {
        self.coordinator = coordinator
        self.user = user
        self.themeProvider = themeProvider
    }
    
    // MARK: - Public methods
    
    func signOut() {
        coordinator?.signOut()
    }
    
    func openThemes() {
        coordinator?.openSelectThemes()
    }
    
    func GEBUG_openExampleColors() {
        coordinator?.GEBUG_openExampleColors()
    }
    
    func hideNavBar() {
        coordinator?.navBarHidden(true)
    }
}
