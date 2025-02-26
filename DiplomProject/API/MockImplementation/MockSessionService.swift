import FirebaseAuth

final class MockSessionService: SessionService {
    
    // MARK: - Private properties
    
    private var state: (any NSObjectProtocol)?
   
    init() {
        state = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self else { return }
            if user == nil {
                sessionDidChande?()
            }
        }
    }
    
    // MARK: - SessionService
    var sessionDidChande: (() -> Void)?
    
    func signOut() {
        try? Auth.auth().signOut()
    }
}
