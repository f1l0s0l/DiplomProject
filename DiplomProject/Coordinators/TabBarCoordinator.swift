import UIKit

final class TabBarCoordinator {
    
    // MARK: - Private properties
    private weak var parentCoordinator: MainCoordinatorParentDelegate?

    private var childCoordinators: [Coordinator] = []    
    private var tabBarController: UITabBarController
    
    private let client: APIClient
    
    // MARK: - Lifecycles

    init(parentCoordinator: MainCoordinatorParentDelegate?, client: APIClient) {
        self.parentCoordinator = parentCoordinator
        tabBarController = UITabBarController()
        self.client = client
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

    private func makeFeedCoordinator() -> Coordinator {
        let feedCoordinator = FeedCoordinator(client: client)
        return feedCoordinator
    }
    
    private func makeSettingsCoordinator() -> Coordinator {
        let settingsCoordinator = SettingsCoordinator()
        return settingsCoordinator
    }
    
    private func setupTabBarController(viewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(viewControllers, animated: false)
        
        tabBarController.tabBar.tintColor = .orange
        tabBarController.tabBar.unselectedItemTintColor = .gray
        tabBarController.tabBar.backgroundColor = .white
    }
}

// MARK: - Coordinator

extension TabBarCoordinator: Coordinator {
    func start() -> UIViewController {
        let feedCoordinator = makeFeedCoordinator()
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
