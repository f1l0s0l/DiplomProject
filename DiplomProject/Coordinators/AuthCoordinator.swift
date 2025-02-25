import UIKit

protocol AuthCoordinatorProtocol: AnyObject {
    func auth()
}

final class AuthCoordinator {
    
    // MARK: - Private Properties
    
    private weak var parentCoordinator: MainCoordinatorParentDelegate?
    
    private var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    
    // MARK: - Lifecycles
    
    init(parentCoordinator: MainCoordinatorParentDelegate?) {
        self.parentCoordinator = parentCoordinator
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

extension AuthCoordinator: Coordinator {
    func start() -> UIViewController {
        let authViewController = AuthViewController(coordinator: self)
        navigationController = UINavigationController(rootViewController: authViewController)
        return navigationController
    }
}


// MARK: - AuthCoordinatorProtocol

extension AuthCoordinator: AuthCoordinatorProtocol {
    func auth() {
        parentCoordinator?.switchToMain()
    }
}
