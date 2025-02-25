import UIKit

protocol MainCoordinatorParentDelegate: AnyObject {
    func switchToMain()
    func switchToAuth()
}

final class MainCoordinator {
    // MARK: - Private properties
    
    private var rootViewController: UIViewController
    private var childCoordinators: [Coordinator] = []
    
    private let client: APIClient
    
    // MARK: - Lifecycles
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        self.client = MockAPIClient()
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
        let tabBarCoordinator = TabBarCoordinator(parentCoordinator: self, client: client)
        addChildCoordinator(tabBarCoordinator)
        return tabBarCoordinator
    }
    
    private func createAuthCoordinator() -> Coordinator {
        let authCoordinator = AuthCoordinator(parentCoordinator: self)
        addChildCoordinator(authCoordinator)
        return authCoordinator
    }
    
    private func checkAuth() -> Bool {
        return false
    }
}

// MARK: - Coordinator

extension MainCoordinator: Coordinator {
    func start() -> UIViewController {
        let coordinator: Coordinator
        if checkAuth() {
            coordinator = createTabBarCoordinator()
        } else {
            coordinator = createAuthCoordinator()
        }
        setFlow(to: coordinator.start())
        return rootViewController
    }
}

// MARK: - MainCoordinatorParentDelegate

extension MainCoordinator: MainCoordinatorParentDelegate {
    func switchToMain() {
        let tabBarCoordinator = createTabBarCoordinator()
        switchFlow(to: tabBarCoordinator.start())
    }
    
    func switchToAuth() {
        let authCoordinator = createAuthCoordinator()
        switchFlow(to: authCoordinator.start())
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
    
    private func switchFlow(to newViewController: UIViewController) {
        self.rootViewController.children[0].willMove(toParent: nil)
        self.rootViewController.children[0].navigationController?.navigationBar.isHidden = true
        self.rootViewController.addChild(newViewController)
        newViewController.view.frame = self.rootViewController.view.bounds
        
        self.rootViewController.transition(
            from: self.rootViewController.children[0],
            to: newViewController,
            duration: 0.6,
            options: [.transitionCrossDissolve, .curveEaseOut],
            animations: {}
        ) { _ in
            self.rootViewController.children[0].removeFromParent()
            newViewController.didMove(toParent: self.rootViewController)
        }
    }
}
