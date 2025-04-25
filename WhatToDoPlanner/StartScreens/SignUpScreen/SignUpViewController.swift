import UIKit

final class SignUpViewController: UIViewController {
    // MARK: - Constants
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
        
        static let titleLabelText: String = "Register"
        static let fontTitleSize: CGFloat = 40
        static let fieldPlaceholderFontSize: CGFloat = 17
        
        // TextField and Button Dimensions
        static let textFieldHeight: CGFloat = 62
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
      
        static let extraKeyboardIndent: CGFloat = 16
    }

    // MARK: - Variables
    var interactor: SignUpInteractorProtocol?

    private let titleLabel: UILabel = UILabel()
    private let firstNameTextField: UITextField = UITextField()
    private let lastNameTextField: UITextField = UITextField()
    private let emailTextField: UITextField = UITextField()
    private let passwordTextField: UITextField = UITextField()
    private var signUpButton: UIButton = UIButton(type: .system)
    private var backButton: UIButton = {
        let button = UIButton(type: .system)
        
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        button.setImage(image, for: .normal)
        
        button.tintColor = .black
        button.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        button.layer.cornerRadius = 35
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.05
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 2
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        
        setupUI()
    }
    
    // MARK: - ViewWillAppear Overriding
    // Subscribing to Keyboard Notifications
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - ViewWillDisappear Overriding
    // Unubscribing to Keyboard Notifications
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
//            textField.font = UIFont(name: Constants.fontName, size: 12.5)
//            textField.tintColor = UIColor(hex: "000000", alpha: 0.9)
            
            if index == 0 {
                NSLayoutConstraint.activate([
                    textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 120)
                ])
                
            } else {
                // Position subsequent text fields below the previous ones
                textField.topAnchor.constraint(equalTo: textFields[index - 1].bottomAnchor, constant: Constants.fieldSpacing).isActive = true
            }
        }

        
    }
    
    
    private func configureBackButton() {
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        // Set SF Symbol and style
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        backButton.setImage(image, for: .normal)
        backButton.setTitle("", for: .normal)
        
        backButton.tintColor = .black
        backButton.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        backButton.layer.cornerRadius = 35
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOpacity = 0.05
        backButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        backButton.layer.shadowRadius = 2
        backButton.clipsToBounds = false

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        // Add constraints
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 73),
            backButton.heightAnchor.constraint(equalToConstant: 73)
        ])
    }

    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: Constants.fontName, size: Constants.fontTitleSize)
        titleLabel.textAlignment = .left
        titleLabel.text = Constants.titleLabelText
        titleLabel.textColor = .black

        // Make sure the backButton is added before this (or use safeArea)
        NSLayoutConstraint.activate([
            // Try anchoring it to the bottom of the backButton instead of safe area
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21)
        ])
    }
    private let firstNameHighlightView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.alpha = 0
        return view
    }()

    private let lastNameHighlightView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.alpha = 0
        return view
    }()

    private let emailHighlightView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.alpha = 0
        return view
    }()

    private let passwordHighlightView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.alpha = 0
        return view
    }()


    private func configureTextField(_ textField: UITextField, placeholder: String) {
        // Existing text field styling
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.backgroundColor = Constants.textFieldColor
        textField.layer.cornerRadius = Constants.textFieldCornerRadius
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hex: "000000", alpha: 0.2)?.cgColor
        textField.textColor = UIColor(hex: "000000", alpha: 0.62)
        textField.font = UIFont(name: Constants.fontName, size: 13)
        textField.borderStyle = .none

        // Secure entry or autocapitalization
        if placeholder == "Email address" || placeholder == "Password" {
            textField.autocapitalizationType = .none
        }
        if placeholder == "Password" {
            textField.isSecureTextEntry = true
        }

        // Position text field
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 49),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -49),
            textField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight)
        ])

        // 1) Determine which highlight view belongs to this text field
        let highlightView: UIView
        switch placeholder {
        case "First Name":
            highlightView = firstNameHighlightView
        case "Last Name":
            highlightView = lastNameHighlightView
        case "Email address":
            highlightView = emailHighlightView
        case "Password":
            highlightView = passwordHighlightView
        default:
            // If you have more placeholders in the future, handle them or return
            return
        }

        // 2) Add highlight view as a subview
        textField.addSubview(highlightView)
        highlightView.translatesAutoresizingMaskIntoConstraints = false

        // 3) Constrain the highlight to the left portion of the text field
        NSLayoutConstraint.activate([
            highlightView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            highlightView.topAnchor.constraint(equalTo: textField.topAnchor),
            highlightView.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            highlightView.widthAnchor.constraint(equalTo: textField.widthAnchor, multiplier: 0.075)
        ])

        // 4) Add editing targets for highlight animation
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        
        let leftPadding: CGFloat = 30 // Adjust if needed
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: Constants.textFieldHeight))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
    }
    @objc private func textFieldDidBeginEditing(_ sender: UITextField) {
        // Identify which highlight to show
        let highlightView = highlightViewFor(sender)
        updateHighlightShape(for: sender, highlightView: highlightView)

        UIView.animate(withDuration: 0.2) {
            highlightView.alpha = 1
        }
    }

    @objc private func textFieldDidEndEditing(_ sender: UITextField) {
        let highlightView = highlightViewFor(sender)

        UIView.animate(withDuration: 0.2) {
            highlightView.alpha = 0
        }
    }
    private func highlightViewFor(_ textField: UITextField) -> UIView {
        switch textField.placeholder {
        case "First Name":
            return firstNameHighlightView
        case "Last Name":
            return lastNameHighlightView
        case "Email address":
            return emailHighlightView
        case "Password":
            return passwordHighlightView
        default:
            return UIView() // Or handle error case
        }
    }
    private func updateHighlightShape(for textField: UITextField, highlightView: UIView) {
        // Remove old shape
        highlightView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        // Build new path
        let path = UIBezierPath(
            roundedRect: highlightView.bounds,
            byRoundingCorners: [.topLeft, .bottomLeft],
            cornerRadii: CGSize(width: textField.layer.cornerRadius, height: textField.layer.cornerRadius)
        )

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor(hex: "#85B7CA", alpha: 0.23)?.cgColor

        highlightView.layer.addSublayer(shapeLayer)
    }




    private func configureSignUpButton() {
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: Constants.fontName, size: 16.6)
        signUpButton.backgroundColor = Constants.buttonBackgroundColor
        signUpButton.setTitleColor(Constants.buttonTitleColor, for: .normal)
        signUpButton.layer.cornerRadius = Constants.buttonCornerRadius
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 49),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -49),
            signUpButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        // Hiding title lable
        UIView.animate(withDuration: 0.3) {
            self.titleLabel.alpha = 0
        }
        
        guard let userInfo = notification.userInfo,
                let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let keyboardHeight = keyboardFrame.height

        // Raise view's elements if the keyboard overlaps the create account button.
        if let passwordFrame = passwordTextField.superview?.convert(passwordTextField.frame, to: nil) {
            let bottomY = passwordFrame.maxY
            let screenHeight = UIScreen.main.bounds.height
        
            if bottomY > screenHeight - keyboardHeight {
                let overlap = bottomY - (screenHeight - keyboardHeight)
                self.view.frame.origin.y -= overlap + Constants.extraKeyboardIndent
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // Returning title lable
        UIView.animate(withDuration: 0.3) {
            self.titleLabel.alpha = 1
        }
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapSignUpButton() {
        interactor?.didTapSignUp(
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
