import UIKit

final class SettingsCoordinator {
    
    // MARK: - Private Properties
    
    private var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    
    // MARK: - Lifecycles
    
    init() {
        navigationController = UINavigationController()
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

extension SettingsCoordinator: Coordinator {
    func start() -> UIViewController {
        let settingsViewController = SettingsViewController()
        settingsViewController.title = "Settings"
        
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        let tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            tag: 1
        )
        navigationController.tabBarItem = tabBarItem
        
        self.navigationController = navigationController
        return self.navigationController
    }
}
