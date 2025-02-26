import UIKit

protocol MainCoordinatorParentDelegate: AnyObject {
    func switchToMain(user: User)
    func switchToAuth()
}

final class MainCoordinator {
    // MARK: - Private properties
    
    private var rootViewController: UIViewController
    private var childCoordinators: [Coordinator] = []
    
    private let session: SessionService
    private let client: APIClient
    private let themeProvider: ThemeProvider
    
    // MARK: - Lifecycles
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        session = MockSessionService()
        client = MockAPIClient()
        
        let themeType = ThemeType(rawValue: UserDefaults.standard.object(forKey: "CurrentThemeType") as? Int ?? 0)
        themeProvider = ThemeProvider(themeType: themeType ?? .bumble)
        
        subscribeSession()
        NotificationCenter.default.addObserver(forName: ThemeProvider.didChangeThemeNotification, object: nil, queue: .main) { [weak self] _ in
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
    
    private func createTabBarCoordinator(user: User) -> Coordinator {
        let tabBarCoordinator = TabBarCoordinator(parentCoordinator: self, client: client, themeProvider: themeProvider, user: user)
        addChildCoordinator(tabBarCoordinator)
        return tabBarCoordinator
    }
    
    private func createAuthCoordinator() -> Coordinator {
        let authCoordinator = AuthCoordinator(parentCoordinator: self, client: client, themeProvider: themeProvider)
        addChildCoordinator(authCoordinator)
        return authCoordinator
    }
    
    private func checkUserAuth(completion: @escaping (User?) -> Void) {
        client.perform(request: API.checkAuth()) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    completion(user)
                case .failure:
                    completion(nil)
                }
            }
        }
    }
    
    private func startWithCheckAuth() {
        checkUserAuth { [weak self] user in
            guard let self else { return }
            DispatchQueue.main.async {
                let coordinator: Coordinator
                if let user {
                    coordinator = self.createTabBarCoordinator(user: user)
                    self.subscribeSession()
                } else {
                    coordinator = self.createAuthCoordinator()
                }
                self.setFlow(to: coordinator.start())
                self.addChildCoordinator(coordinator)
            }
        }
    }
    
    private func subscribeSession() {
        session.sessionDidChande = { [weak self] in
            guard let self else { return }
            
            let authCoordinator = createAuthCoordinator()
            switchFlow(to: authCoordinator.start())
            
            childCoordinators.removeAll()
            addChildCoordinator(authCoordinator)
        }
    }
    
    private func applyTheme() {
        UINavigationBar.appearance().tintColor = themeProvider.navigationBarTheme.title
        UINavigationBar.appearance().backgroundColor = themeProvider.navigationBarTheme.background
    }
}

// MARK: - Coordinator

extension MainCoordinator: Coordinator {
    func start() -> UIViewController {
        startWithCheckAuth()
        return rootViewController
    }
}

// MARK: - MainCoordinatorParentDelegate

extension MainCoordinator: MainCoordinatorParentDelegate {
    func switchToMain(user: User) {
        let tabBarCoordinator = createTabBarCoordinator(user: user)
        switchFlow(to: tabBarCoordinator.start())
        
        childCoordinators.removeAll()
        addChildCoordinator(tabBarCoordinator)
    }
    
    func switchToAuth() {
        let authCoordinator = createAuthCoordinator()
        switchFlow(to: authCoordinator.start())
        
        childCoordinators.removeAll()
        addChildCoordinator(authCoordinator)
        
        session.sessionDidChande = nil
        session.signOut()
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
