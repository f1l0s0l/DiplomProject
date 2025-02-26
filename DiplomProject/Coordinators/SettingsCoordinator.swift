import UIKit

protocol SettingsCoordinatorProtocol: AnyObject {
    func signOut()
    func openSelectThemes()
    func navBarHidden(_ isHidden: Bool)
    func GEBUG_openExampleColors()
}

final class SettingsCoordinator {
    
    // MARK: - Private Properties
    
    private var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    
    private weak var parentCoordinator: TabBarCoordinatorParentProtocol?
    
    private let user: User
    private let themeProvider: ThemeProvider
    
    // MARK: - Lifecycles
    
    init(parentCoordinator: TabBarCoordinatorParentProtocol?, user: User, themeProvider: ThemeProvider) {
        navigationController = UINavigationController()
        self.parentCoordinator = parentCoordinator
        self.user = user
        self.themeProvider = themeProvider
    }
    
    // MARK: - Private Methods
    
    private func addChildCoordinator(_ coordinator: Coordinator) {
        guard !self.childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        self.childCoordinators.append(coordinator)
    }
    
    private func removeChildCoordinator(_ coordinator: Coordinator) {
        self.childCoordinators.removeAll(where: {$0 === coordinator})
    }
    
    private func createExampleColorsCoordinator() -> Coordinator {
        let coordinator = ExampleColorsCoordinator(themeProvider: themeProvider)
        return coordinator
    }
}

// MARK: - Coordinator

extension SettingsCoordinator: Coordinator {
    func start() -> UIViewController {
        let settingsViewModel = SettingsViewModel(coordinator: self, user: user, themeProvider: themeProvider)
        let settingsViewController = SettingsViewController(viewModel: settingsViewModel)
        settingsViewController.title = "Settings"
        
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        let tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            tag: 1
        )
        navigationController.tabBarItem = tabBarItem
        navigationController.navigationBar.isHidden = true
        
        self.navigationController = navigationController
        return self.navigationController
    }
}

// MARK: - SettingsCoordinatorProtocol

extension SettingsCoordinator: SettingsCoordinatorProtocol {
    func navBarHidden(_ isHidden: Bool) {
        navigationController.navigationBar.isHidden = isHidden
    }
    
    func signOut() {
        parentCoordinator?.signOut()
    }
    
    func openSelectThemes() {
        let viewModel = SelectThemesViewModel(themeProvider: themeProvider, coodrinator: self)
        let selectThemesViewController = SelectThemesViewController(viewModel: viewModel)
        
        selectThemesViewController.title = "Оформление"
        
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(selectThemesViewController, animated: true)
    }
    
    func GEBUG_openExampleColors() {
        let coordinator = createExampleColorsCoordinator()
        addChildCoordinator(coordinator)
        
        navigationController.present(coordinator.start(), animated: true)
    }
}
