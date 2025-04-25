import UIKit

final class ChangePasswordViewController: UIViewController {
    var interactor: ChangePasswordBusinessLogic?
    var email: String

//    private let backButton: UIButton = {
//        let backButton = UIButton(type: .system)
//
//        // Use SF Symbol arrow
//        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
//        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
//        backButton.setImage(image, for: .normal)
//
//        backButton.tintColor = .black
//        backButton.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
//        backButton.layer.cornerRadius = 35
//        backButton.layer.shadowColor = UIColor.black.cgColor
//        backButton.layer.shadowOpacity = 0.05
//        backButton.layer.shadowOffset = CGSize(width: 0, height: 1)
//        backButton.layer.shadowRadius = 2
//        backButton.clipsToBounds = false
//        return backButton
//    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Change Password"
        label.font = UIFont(name: "AoboshiOne-Regular", size: 34)
        label.textColor = .black
        return label
    }()
    
    private let passwordFormatLabel: UILabel = {
        let label = UILabel()
        label.text = "The size of shouldn't be less than 6 elements. It should contains 1 capital letter (A-Z), 1 small letter (a-z), 1 digit (1-9) and 1 special charachter (!$%&'()*+,-./:;<>)"
        label.numberOfLines = 0
        label.font = UIFont(name: "AoboshiOne-Regular", size: 16)
        label.textColor = .black
        return label
    }()

    private let passwordField = ChangePasswordTextField(placeholder: "Enter new password")
    private let newPasswordField = ChangePasswordTextField(placeholder: "New password")

    private let continueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue to app", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AoboshiOne-Regular", size: 17)
        btn.backgroundColor = UIColor(red: 208/255, green: 232/255, blue: 200/255, alpha: 1.0)
        btn.layer.cornerRadius = 14
        return btn
    }()
    
    init(interactor: ChangePasswordBusinessLogic?, email: String) {
        self.interactor = interactor
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        
        super.viewDidLoad()
        view.backgroundColor = .white
        passwordField.isSecureTextEntry = true
        setupLayout()
        setupActions()
    }
    
    func navigateToApp() {
        let welcomeVC = WelcomeModuleAssembly.assembly()
        navigationController?.setViewControllers([welcomeVC], animated: true)
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func returnContinueButton() {
        continueButton.isEnabled = true
        continueButton.alpha = 1
    }

    private func setupLayout() {
        [ titleLabel, passwordFormatLabel, passwordField, continueButton ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            // Title at top
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 20
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 32
            ),
            
            
            // Password label
            passwordFormatLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 20
            ),
            
            passwordFormatLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            
            passwordFormatLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),

            // Password field below title
            passwordField.topAnchor.constraint(
                equalTo: passwordFormatLabel.bottomAnchor,
                constant: 50
            ),
            passwordField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 32
            ),
            passwordField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -32
            ),
            passwordField.heightAnchor.constraint(
                equalToConstant: 58
            ),

            // Continue button below password field
            continueButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            ),
            continueButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 48
            ),
            continueButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -48
            ),
            continueButton.heightAnchor.constraint(
                equalToConstant: 50
            ),
        ])
    }


    private func setupActions() {
//        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
    }

    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func handleContinue() {
        continueButton.isEnabled = false
        continueButton.alpha = 0.5
        let newPassword = passwordField.text ?? ""
//        let newPassword = newPasswordField.text ?? ""
        interactor?.submitChange(request: ChangePasswordModels.Request(email: email, newPassword: newPassword))
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

}

private class ChangePasswordTextField: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.font = UIFont(name: "AoboshiOne-Regular", size: 16)
        self.backgroundColor = .white
        self.layer.cornerRadius = 14
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        self.layer.borderWidth = 1
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        self.leftView = padding
        self.leftViewMode = .always
        self.autocapitalizationType = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
