import UIKit

protocol TabBarCoordinatorParentProtocol: AnyObject {
    func signOut()
}

final class TabBarCoordinator {
    
    // MARK: - Private properties
    private weak var parentCoordinator: MainCoordinatorParentDelegate?

    private var childCoordinators: [Coordinator] = []    
    private var tabBarController: UITabBarController
    
    private let client: APIClient
    private let themeProvider: ThemeProvider
    private let user: User
    
    // MARK: - Lifecycles

    init(parentCoordinator: MainCoordinatorParentDelegate?, client: APIClient, themeProvider: ThemeProvider, user: User) {
        self.parentCoordinator = parentCoordinator
        tabBarController = UITabBarController()
        self.client = client
        self.themeProvider = themeProvider
        self.user = user
        
        NotificationCenter.default.addObserver(
            forName: ThemeProvider.didChangeThemeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            applyTheme()
        }
    }
    
    // MARK: - Private methods
    
    private func addChildCoordinator(_ coordinator: Coordinator) {
        guard !self.childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        self.childCoordinators.append(coordinator)
    }
    
    private func removeChildCoordinator(_ coordinator: Coordinator) {
        self.childCoordinators.removeAll(where: {$0 === coordinator})
    }

    private func makeFeedCoordinator(user: User) -> Coordinator {
        let feedCoordinator = FeedCoordinator(client: client, themeProvider: themeProvider, user: user)
        return feedCoordinator
    }
    
    private func makeSettingsCoordinator() -> Coordinator {
        let settingsCoordinator = SettingsCoordinator(parentCoordinator: self, user: user, themeProvider: themeProvider)
        return settingsCoordinator
    }
    
    private func setupTabBarController(viewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(viewControllers, animated: false)
        
        applyTheme()
    }
    
    private func applyTheme() {
        tabBarController.tabBar.tintColor = themeProvider.tabBarTheme.icon.primary
        tabBarController.tabBar.unselectedItemTintColor = themeProvider.tabBarTheme.icon.secondary
        tabBarController.tabBar.backgroundColor = themeProvider.tabBarTheme.background
    }
}

// MARK: - Coordinator

extension TabBarCoordinator: Coordinator {
    func start() -> UIViewController {
        let feedCoordinator = makeFeedCoordinator(user: user)
        addChildCoordinator(feedCoordinator)
        
        let settingsCoordinator = makeSettingsCoordinator()
        addChildCoordinator(settingsCoordinator)
        
        setupTabBarController(viewControllers: [
            feedCoordinator.start(),
            settingsCoordinator.start()
        ])
                
        return self.tabBarController
    }
}


extension TabBarCoordinator: TabBarCoordinatorParentProtocol {
    func signOut() {
        parentCoordinator?.switchToAuth()
    }
}
