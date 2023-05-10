//
//  ViewController.swift
//  mvvm-login-app
//
//  Created by KARLOS AGUIRRE on 5/9/23.
//

import UIKit
import Combine

class LoginView: UIViewController {
    
    private let loginViewModel = LoginViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add email"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Login"
        configuration.subtitle = "Suscribete!"
        configuration.image = UIImage(systemName: "play.circle.fill")
        configuration.imagePadding = 8
        
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] action in
            self?.startLogin()
        }))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = configuration
        return button
    }()
    
    private let errorLbl: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .red
        label.font = .systemFont(ofSize: 20, weight: .regular, width: .condensed)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createBindingViewWithViewModel()
    }
    
    private func setupUI() {
        [emailTextField, passwordTextField, loginButton, errorLbl].forEach(view.addSubview)
        NSLayoutConstraint.activate([
            
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -20),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            passwordTextField.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLbl.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
        ])
    }
    
    private func startLogin() {
        loginViewModel.userLogin(with: emailTextField.text?.lowercased() ?? "", password: passwordTextField.text?.lowercased() ?? "")
    }
    
    private func createBindingViewWithViewModel() {
        emailTextField.textPublisher.assign(to: \LoginViewModel.email, on: loginViewModel).store(in: &cancellables)
        passwordTextField.textPublisher.assign(to: \LoginViewModel.password, on: loginViewModel).store(in: &cancellables)
        loginViewModel.$loginButtonIsEnabled.assign(to: \.isEnabled, on: loginButton).store(in: &cancellables)
        loginViewModel.$isLoading.assign(to: \.configuration!.showsActivityIndicator, on: loginButton).store(in: &cancellables)
        loginViewModel.$errorMessage.assign(to: \UILabel.text!, on: errorLbl).store(in: &cancellables)
        loginViewModel.$userModel.sink { [weak self] user in
            guard user != nil else { return }
            self?.present(HomeView(), animated: true)
        }.store(in: &cancellables)
    }

}

extension UITextField {
    var textPublisher:AnyPublisher<String, Never> {
        return NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { notification in
                return (notification.object as? UITextField)?.text ?? ""
            }
            .eraseToAnyPublisher()
    }
}

