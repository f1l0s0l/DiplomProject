import UIKit

final class FeedCoordinator {
    
    // MARK: - Private Properties
    
    private var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    
    private let client: APIClient
    private let themeProvider: ThemeProvider
    private let user: User
    
    // MARK: - Lifecycles
    
    init(client: APIClient, themeProvider: ThemeProvider, user: User) {
        navigationController = UINavigationController()
        self.client = client
        self.themeProvider = themeProvider
        self.user = user
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
        let viewModel = FeedViewModel(client: client, themeProvider: themeProvider, user: user)
        let feedViewController = FeedViewController(viewModel: viewModel)
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
