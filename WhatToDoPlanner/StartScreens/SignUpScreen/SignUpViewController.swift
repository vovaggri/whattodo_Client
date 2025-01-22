import UIKit

protocol SignUpViewProtocol: AnyObject {
    func showError(message: String)
}

final class SignUpViewController: UIViewController {
    // MARK: - Constants
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
        
        static let titleLabelText: String = "Register"
        static let fontTitleSize: CGFloat = 40
        static let fieldPlaceholderFontSize: CGFloat = 17
        
        // TextField and Button Dimensions
        static let textFieldHeight: CGFloat = 50
        static let textFieldCornerRadius: CGFloat = 14
        static let buttonHeight: CGFloat = 42
        static let buttonWidth: CGFloat = 50
        static let buttonCornerRadius: CGFloat = 14
        static let fieldSpacing: CGFloat = 40
        static let sidePadding: CGFloat = 20
        static let textFieldColor: UIColor = .white
        
        // Button Colors
        static let buttonBackgroundColor: UIColor = UIColor(hex: "94CA85", alpha: 0.35) ?? .systemGreen.withAlphaComponent(0.35)
        static let buttonTitleColor: UIColor = UIColor(hex: "000000", alpha: 0.6) ?? .darkGray
      
    }

    // MARK: - Variables
    var presenter: SignUpPresenterProtocol?

    private let titleLabel: UILabel = UILabel()
    private let firstNameTextField: UITextField = UITextField()
    private let lastNameTextField: UITextField = UITextField()
    private let emailTextField: UITextField = UITextField()
    private let passwordTextField: UITextField = UITextField()
    private var signUpButton: UIButton = UIButton(type: .system)
    private var backButton = UIButton(type: .system)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        
        setupUI()
    }

    // MARK: - Private Functions
    private func setupUI() {
        configureBackButton()
        configureTitleLabel()
        configureSignUpButton()
        
        // Adjustments for centering the fields
        view.addSubview(firstNameTextField)
        view.addSubview(lastNameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)

        let textFields = [firstNameTextField, lastNameTextField, emailTextField, passwordTextField]

        for (index, textField) in textFields.enumerated() {
            configureTextField(textField, placeholder: ["First Name", "Last Name", "Email address", "Password"][index])
            textField.font = UIFont(name: Constants.fontName, size: 15)
            
            if index == 0 {
                NSLayoutConstraint.activate([
                    textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20)
                ])
                
            } else {
                // Position subsequent text fields below the previous ones
                textField.topAnchor.constraint(equalTo: textFields[index - 1].bottomAnchor, constant: Constants.fieldSpacing).isActive = true
            }
        }

        
    }
    
    private func configureBackButton() {
        view.addSubview(backButton)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal) // Use custom image
        backButton.setTitle("", for: .normal) // Remove text
        backButton.tintColor = UIColor(hex: "000000", alpha: 0.4) // Change the color if needed
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: Constants.fontName, size: Constants.fontTitleSize)
        titleLabel.textAlignment = .left
        titleLabel.text = Constants.titleLabelText
        titleLabel.textColor = .black
        

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21)
        ])
    }

    private func configureTextField(_ textField: UITextField, placeholder: String) {
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = placeholder
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = Constants.textFieldCornerRadius
        textField.backgroundColor = Constants.textFieldColor

        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Center horizontally
            textField.widthAnchor.constraint(equalTo: signUpButton.widthAnchor), // Match button width
            textField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight) // Set fixed height
        ])
    }

    private func configureSignUpButton() {
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: Constants.fontName, size: 14)
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

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapSignUpButton() {
        presenter?.didTapSignUp(
            firstName: firstNameTextField.text,
            lastName: lastNameTextField.text,
            email: emailTextField.text,
            password: passwordTextField.text
        )
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
