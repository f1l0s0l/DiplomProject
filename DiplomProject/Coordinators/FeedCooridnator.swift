import UIKit

final class FeedCoordinator {
    // MARK: - Private Properties
    
    private var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    
    // MARK: - Lifecycles
    
    init() {
        self.navigationController = UINavigationController()
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
}

// MARK: - Coordinator

extension FeedCoordinator: Coordinator {
    func start() -> UIViewController {
        let model = FeedViewModel()
        let feedViewController = FeedViewController(model: model)
        feedViewController.title = "Feed"
        
        let navigationController = UINavigationController(rootViewController: feedViewController)
        let tabBarItem = UITabBarItem(
            title: "Feed",
            image: UIImage(systemName: "square.stack"),
            tag: 0
        )
        navigationController.tabBarItem = tabBarItem
        
        self.navigationController = navigationController
        return self.navigationController
    }
}
