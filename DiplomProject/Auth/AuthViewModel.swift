import Foundation

final class AuthViewModel {
    
    // MARK: - Public properties
    
    var stateChanged: ((State) -> Void)?
    
    private(set) var state: State = .initial {
        didSet {
            stateChanged?(state)
        }
    }
    
    // MARK: - Private properties
    
    private weak var coordinator: AuthCoordinatorProtocol?
    private let client: APIClient
    private let themeProvider: ThemeProvider
    
    init(coordinator: AuthCoordinatorProtocol?, client: APIClient, themeProvider: ThemeProvider) {
        self.coordinator = coordinator
        self.client = client
        self.themeProvider = themeProvider
    }
    
    // MARK: - Public methods
    
    func logind(email: String, password: String) {
        state = .loading
        
        let request = API.login(email: email, password: password)
        client.perform(request: request) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.state = .loaded
                    self.coordinator?.auth(user: user)
                case .failure(let error):
                    self.state = .wrong(error: error.localizedDescription)
                }
            }
        }
    }
}

extension AuthViewModel {
    enum State {
        case initial
        case loading
        case loaded
        case wrong(error: String)
    }
}
