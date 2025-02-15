import UIKit

final class MainCoordinator {
    // MARK: - Private properties
    
    private var rootViewController: UIViewController
    private var childCoordinators: [Coordinator] = []
    
    // MARK: - Lifecycles
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
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
    
    private func createTabBarCoordinator() -> Coordinator {
        let tabBarCoordinator = TabBarCoordinator()
        addChildCoordinator(tabBarCoordinator)
        return tabBarCoordinator
    }
}

// MARK: - Coordinator

extension MainCoordinator: Coordinator {
    func start() -> UIViewController {
        let tabBarCoordinator = createTabBarCoordinator()
        setFlow(to: tabBarCoordinator.start())
        return rootViewController
    }
}

// MARK: Set / Switch Flow

extension MainCoordinator {
    private func setFlow(to newViewController: UIViewController) {
        self.rootViewController.addChild(newViewController)
        newViewController.view.frame = self.rootViewController.view.bounds
        self.rootViewController.view.addSubview(newViewController.view)
        newViewController.didMove(toParent: self.rootViewController)
    }
}
