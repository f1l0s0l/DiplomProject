import UIKit
import FirebaseAuth

final class AuthViewController: UIViewController {
    
    // MARK: - Private priperties
    
    private let viewModel: AuthViewModel
    private weak var coordinator: AuthCoordinatorProtocol?
    
    private let backgroundLoadingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = .black.withAlphaComponent(0.3)
        return view
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.isHidden = true
        return activityIndicatorView
    }()

    private let emailTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.placeholder = "Введите email"
        textField.text = nil
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        return textField
    }()

    private let passwordTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.placeholder = "Введите пароль"
        textField.isSecureTextEntry = true
        textField.text = nil
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private var loginButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycles
    
    init(coordinator: AuthCoordinatorProtocol, viewModel: AuthViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
              
        [
            emailTextField,
            passwordTextField,
            loginButton,
            backgroundLoadingView,
            activityIndicatorView
        ].forEach(view.addSubview)
        
        setupConstraint()
        setupKeyboardObservers()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapSuperView))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        bindViewModel()
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        viewModel.stateChanged = { [weak self] state in
            guard let self else { return }
            view.endEditing(true)
            
            switch state {
            case .initial:
                break
            case .loading:
                updateActivityIndiator(started: true)
            case .loaded:
                updateActivityIndiator(started: false)
            case .wrong(let error):
                updateActivityIndiator(started: false)
                showAlert(message: error)
            }
        }
    }
    
    private func setupConstraint() {
        loginButtonBottomConstraint = loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            loginButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButtonBottomConstraint,
            
            backgroundLoadingView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundLoadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundLoadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundLoadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func updateActivityIndiator(started: Bool) {
        if started {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
        
        activityIndicatorView.isHidden = started ? false : true
        backgroundLoadingView.isHidden = started ? false : true
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
           view.frame.height - keyboardFrame.height < loginButton.frame.maxY {
            UIView.animate(withDuration: animationDuration) {
                self.loginButtonBottomConstraint.constant = -keyboardFrame.height - 5
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: animationDuration) {
                self.loginButtonBottomConstraint.constant = -25
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func loginTapped() {
        //"user1@gmail.com"
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(message: "Введите email")
            return
        }
        //qwerty
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Введите пароль")
            return
        }
        
        viewModel.logind(email: email, password: password)
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
    
    @objc private func didTapSuperView() {
        view.endEditing(true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - PaddedTextField

final class PaddedTextField: UITextField {
    var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
