import UIKit

protocol AuthCoordinatorProtocol: AnyObject {
    func auth(user: User)
}

final class AuthCoordinator {
    
    // MARK: - Private Properties
    
    private weak var parentCoordinator: MainCoordinatorParentDelegate?
    
    private var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    
    private let client: APIClient
    private let themeProvider: ThemeProvider
    
    // MARK: - Lifecycles
    
    init(parentCoordinator: MainCoordinatorParentDelegate?, client: APIClient, themeProvider: ThemeProvider) {
        self.parentCoordinator = parentCoordinator
        navigationController = UINavigationController()
        self.client = client
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
}

// MARK: - Coordinator

extension AuthCoordinator: Coordinator {
    func start() -> UIViewController {
        let authViewModel = AuthViewModel(coordinator: self, client: client, themeProvider: themeProvider)
        let authViewController = AuthViewController(coordinator: self, viewModel: authViewModel)
        navigationController = UINavigationController(rootViewController: authViewController)
        return navigationController
    }
}


// MARK: - AuthCoordinatorProtocol

extension AuthCoordinator: AuthCoordinatorProtocol {
    func auth(user: User) {
        parentCoordinator?.switchToMain(user: user)
    }
}
