import UIKit
import FirebaseAuth

final class AuthViewController: UIViewController {
    
    private weak var coordinator: AuthCoordinatorProtocol?

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите email"
        textField.borderStyle = .roundedRect
        textField.text = nil
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите пароль"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.text = nil
        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()

    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Регистрация", for: .normal)
        button.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycles
    
    init(coordinator: AuthCoordinatorProtocol? = nil) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        
        
        let client = MockAPIClient()
        let request = API.getFriends(parameters: [:], userId: "UHwc5gRdVObEFnb66qymee9Exim1")
        client.perform(request: request) { result in
            switch result {
            case .success(let friends):
                print(friends)
            case .failure(let error):
                print("ОШИБКА!!!!! \(error)")
            }
        }
    }

    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, registerButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }

    @objc private func loginTapped() {
//        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
//            showAlert(message: "Введите email и пароль")
//            return
//        }
        let email = emailTextField.text == nil || emailTextField.text == "" ? "user1@gmail.com" : emailTextField.text!
        let password = passwordTextField.text == nil || passwordTextField.text == "" ? "qwerty" : passwordTextField.text!

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.showAlert(message: "Ошибка входа: \(error.localizedDescription)")
                return
            } else {
                self?.coordinator?.auth()
            }
        }
    }

    @objc private func registerTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            showAlert(message: "Введите email и пароль")
            return
        }

//        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
//            if let error = error {
//                self?.showAlert(message: "Ошибка регистрации: \(error.localizedDescription)")
//                return
//            }
//            self?.saveUserToFirestore()
//        }
    }

//    private func saveUserToFirestore() {
//        guard let user = Auth.auth().currentUser else { return }
//        let db = Firestore.firestore()
//        let userData: [String: Any] = [
//            "name": user.email ?? "Без имени",
//            "profilePicture": "https://example.com/avatar.jpg",
//            "friends": []
//        ]
//
//        db.collection("users").document(user.uid).setData(userData) { [weak self] error in
//            if let error = error {
//                self?.showAlert(message: "Ошибка сохранения данных: \(error.localizedDescription)")
//                return
//            }
//            self?.navigateToMainScreen()
//        }
//    }

//    private func navigateToMainScreen() {
//        let mainVC = MainViewController()
//        let navController = UINavigationController(rootViewController: mainVC)
//        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
//            sceneDelegate.window?.rootViewController = navController
//        }
//    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}
