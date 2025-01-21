import UIKit

protocol SignUpViewProtocol: AnyObject {
    func showError(message: String)
}

protocol SignUpPresenterProtocol: AnyObject {
    var view: SignUpViewProtocol? { get set } 
    func didTapSignUp(firstName: String?, lastName: String?, email: String?, password: String?)
}

protocol SignUpInteractorProtocol: AnyObject {
    func validateAndSignUp(firstName: String, lastName: String, email: String, password: String)
}

protocol SignUpRouterProtocol: AnyObject {
    func navigateToNextScreen()
}


import UIKit

final class SignUpViewController: UIViewController {
    // MARK: - Constants
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
        
        static let titleLabelText: String = "Register"
        static let fontTitleSize: CGFloat = 34
        static let fieldPlaceholderFontSize: CGFloat = 17
        
        // TextField and Button Dimensions
        static let textFieldHeight: CGFloat = 50
        static let textFieldCornerRadius: CGFloat = 8
        static let buttonHeight: CGFloat = 50
        static let buttonWidth: CGFloat = 50
        static let buttonCornerRadius: CGFloat = 8
        static let fieldSpacing: CGFloat = 20
        static let sidePadding: CGFloat = 20
        
        // Button Colors
        static let buttonBackgroundColor: UIColor = UIColor.systemGreen.withAlphaComponent(0.3)
        static let buttonTitleColor: UIColor = .darkGray
    }

    // MARK: - Variables
    var presenter: SignUpPresenterProtocol?

    private let titleLabel: UILabel = UILabel()
    private let firstNameTextField: UITextField = UITextField()
    private let lastNameTextField: UITextField = UITextField()
    private let emailTextField: UITextField = UITextField()
    private let passwordTextField: UITextField = UITextField()
    private lazy var signUpButton: UIButton = UIButton(type: .system)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    // MARK: - Private Functions
    private func setupUI() {
        configureTitleLabel()
        configureTextField(firstNameTextField, placeholder: "First Name")
        configureTextField(lastNameTextField, placeholder: "Last Name")
        configureTextField(emailTextField, placeholder: "Email address")
        configureTextField(passwordTextField, placeholder: "Password")
        configureSignUpButton()
    }

    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.fontTitleSize)
        titleLabel.textAlignment = .left
        titleLabel.text = Constants.titleLabelText
        titleLabel.textColor = .black

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sidePadding)
        ])
    }

    private func configureTextField(_ textField: UITextField, placeholder: String) {
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = placeholder
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = Constants.textFieldCornerRadius

        let previousView: UIView = {
            switch textField {
            case firstNameTextField: return titleLabel
            case lastNameTextField: return firstNameTextField
            case emailTextField: return lastNameTextField
            case passwordTextField: return emailTextField
            default: return view
            }
        }()

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: Constants.fieldSpacing),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sidePadding),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sidePadding),
            textField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight)
        ])
    }

    private func configureSignUpButton() {
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = Constants.buttonBackgroundColor
        signUpButton.setTitleColor(Constants.buttonTitleColor, for: .normal)
        signUpButton.layer.cornerRadius = Constants.buttonCornerRadius
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)

        let adjustedWidth = UIScreen.main.bounds.width * 0.8 // Reduce width to 80% of the screen width
        let adjustedHeight = Constants.buttonHeight

        NSLayoutConstraint.activate([
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Center horizontally
            signUpButton.widthAnchor.constraint(equalToConstant: adjustedWidth), // Set the button's width
            signUpButton.heightAnchor.constraint(equalToConstant: adjustedHeight), // Set the button's height
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20) // Keep the button at the bottom
        ])
    }


    @objc private func didTapSignUpButton() {
        presenter?.didTapSignUp(
            firstName: firstNameTextField.text,
            lastName: lastNameTextField.text,
            email: emailTextField.text,
            password: passwordTextField.text
        )
    }
}

// MARK: - SignUpViewProtocol
extension SignUpViewController: SignUpViewProtocol {
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
