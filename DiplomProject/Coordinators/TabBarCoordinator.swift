import UIKit

final class TabBarCoordinator {
    
    // MARK: - Private properties
    private var childCoordinators: [Coordinator] = []
    
    private var tabBarController: UITabBarController
    
    // MARK: - Lifecycles

    init() {
        tabBarController = UITabBarController()
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
        let feedCoordinator = FeedCoordinator()
        return feedCoordinator
    }
    
    private func setupTabBarController(viewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(viewControllers, animated: false)
        self.tabBarController.tabBar.backgroundColor = .white
        self.tabBarController.tabBar.tintColor = .black
    }
}

// MARK: - Coordinator

extension TabBarCoordinator: Coordinator {
    func start() -> UIViewController {
        let feedCoordinator = self.makeFeedCoordinator()
        self.addChildCoordinator(feedCoordinator)

        self.setupTabBarController(viewControllers: [
            feedCoordinator.start()
        ])
                
        return self.tabBarController
    }
}
