//
//  ViewController.swift
//  WhatToDo Planner
//
//  Created by Vladimir Grigoryev on 15.01.2025.
//

import UIKit

final class WelcomeViewController: UIViewController  {
    // MARK: - Enum
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
        
        // Welcome labels
        static let firstLabelText: String = "Welcome"
        static let secondLabelText: String = "To"
        static let thirdLabelText: String = "WhatToDo"
        static let descriptionText: String = "Because every great achievment starts with a plan"
        
        static let fontWelcomeSize: CGFloat = 40
        
        static let firstLabelTop: Double = 108
        
        static let secondLabelTop: Double = 60
        static let thirdLabelTop: Double = 60
        
        static let labelLeft: Double = 21
        
        // SignUp button
        static let signUoButtonText: String = "Sign Up"
        
        // Text fields
        static let fieldRaduis: CGFloat = 14
        static let borderFieldWidth: CGFloat = 1
        static let heightField: Double = 61
        static let paddingViewWidth: CGFloat = 10
        static let padding: CGFloat = 49
        static let textFieldHeight: CGFloat = 62
        
        static let fontTextFieldsLabelSize: CGFloat = 15
        static let fontTextFieldsSize: CGFloat = 13
        static let textFieldCornerRadius: CGFloat = 14
        
        static let emailLabelText: String = "Email adress"
        static let emailPlaceholder: String = "Email adress"
        static let emailLabelLeft: Double = 49
        static let emailTextFieldTop: Double = 180
        
        static let passwordLabelText: String = "Password"
        static let passwordPlaceholder: String = "Password"
        static let passwordLabelLeft: Double = 49
        static let passwordTextFieldTop: Double = 20
        
        // Forget password button
        static let forgetPasswordButtonTitle: String = "Forgot password?"
        static let forgetPasswordButtonSize: CGFloat = 12
        static let forgetPasswordButtonTop: Double = 18
        static let extraKeyboardIndent: CGFloat = 16
    }
    
    // MARK: - Variables
    var interactor: WelcomeBusinessLogic?
    
    private let firstLabel: UILabel = UILabel()
    private let secondLabel: UILabel = UILabel()
    private let thirdLabel: UILabel = UILabel()
    
    private let descriptionLabel: UILabel = UILabel()
    
    private let emailLabel: UILabel = UILabel()
    private let passwordLabel: UILabel = UILabel()
    private let emailTextField: UITextField = UITextField()
    private let passwordTextField: UITextField = UITextField()
    
    private var signUpButton: UIButton = UIButton(type: .system)
    private var loginButton: UIButton = UIButton(type: .system)
    private var forgetPasswordButton: UIButton = UIButton(type: .system)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        
        super.viewDidLoad()
        view.backgroundColor = .white
        configureWelcomeLabeles()
        configureEmailTextField()
        configurePasswordTextField()
        configureForgetPasswordButton()
        configureSignUpButton()
        configureLoginButton()
        configureDescriptionLabel()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emailHighlightView.frame = emailTextField.bounds // Ensure it's inside bounds
        updateEmailHighlightShape()
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
    
    // MARK: - Functions
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func returnActiveLoginButton() {
        loginButton.isEnabled = true
        loginButton.alpha = 1.0
    }

    // MARK: - Private functions
    private func configureWelcomeLabeles() {
        view.addSubview(firstLabel)
        view.addSubview(secondLabel)
        view.addSubview(thirdLabel)
        
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdLabel.translatesAutoresizingMaskIntoConstraints = false
        
        firstLabel.font = UIFont(name: Constants.fontName, size: Constants.fontWelcomeSize)
        secondLabel.font = UIFont(name: Constants.fontName, size: Constants.fontWelcomeSize)
        thirdLabel.font = UIFont(name: Constants.fontName, size: Constants.fontWelcomeSize)
        
        firstLabel.text = Constants.firstLabelText
        firstLabel.pinTop(to: view, Constants.firstLabelTop)
        firstLabel.pinLeft(to: view, Constants.labelLeft)
        firstLabel.textColor = UIColor(hex: "000000")
        
        secondLabel.text = Constants.secondLabelText
        secondLabel.pinLeft(to: view, Constants.labelLeft)
        secondLabel.pinTop(to: firstLabel, Constants.secondLabelTop)
        secondLabel.textColor = UIColor(hex: "000000")
        
        let attributedThirdLabel = NSMutableAttributedString(string: Constants.thirdLabelText)
        attributedThirdLabel.addAttribute(.foregroundColor, value: UIColor(hex: "#85B7CA") ?? .blue, range: NSRange(location: 0, length: 4)) // what
        attributedThirdLabel.addAttribute(.foregroundColor, value: UIColor(hex: "#94CA85") ?? .green, range: NSRange(location: 4, length: 2)) // to
        attributedThirdLabel.addAttribute(.foregroundColor, value: UIColor(hex: "#D6C69E") ?? .brown, range: NSRange(location: 6, length: 2)) // do
        
        thirdLabel.attributedText = attributedThirdLabel
        thirdLabel.pinLeft(to: view, Constants.labelLeft)
        thirdLabel.pinTop(to: secondLabel, Constants.thirdLabelTop)
    }

    private func configureDescriptionLabel() {
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.font = UIFont(name: Constants.fontName, size: 16)
        descriptionLabel.textColor = UIColor(hex: "000000", alpha: 0.39)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = Constants.descriptionText
        
        descriptionLabel.pinTop(to: thirdLabel.bottomAnchor, 117)
//        descriptionLabel.pinLeft(to: view, 40)
//        descriptionLabel.pinRight(to: view, 40)
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.62).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }

    private let emailHighlightView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.masksToBounds = true
        view.alpha = 0 // Initially hidden
        return view
    }()

    private func configureEmailTextField() {
        view.addSubview(emailTextField)
        emailTextField.addSubview(emailHighlightView)

        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailHighlightView.translatesAutoresizingMaskIntoConstraints = false

        emailTextField.autocapitalizationType = .none
        emailTextField.placeholder = Constants.emailPlaceholder
        emailTextField.layer.borderWidth = Constants.borderFieldWidth
        emailTextField.layer.borderColor = UIColor(hex: "000000", alpha: 0.2)?.cgColor
        emailTextField.layer.cornerRadius = Constants.textFieldCornerRadius
        emailTextField.textColor = UIColor(hex: "000000", alpha: 0.62)
        emailTextField.font = UIFont(name: Constants.fontName, size: Constants.fontTextFieldsSize)

        emailTextField.setHeight(Constants.textFieldHeight)
        emailTextField.pinLeft(to: view, Constants.padding)
        emailTextField.pinRight(to: view, Constants.padding)
        emailTextField.pinTop(to: thirdLabel.bottomAnchor, Constants.emailTextFieldTop)

        // 🔹 Left padding to match password field
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.paddingViewWidth + 20, height: emailTextField.frame.height))
        emailTextField.leftView = leftPaddingView
        emailTextField.leftViewMode = .always

        // 🔹 Constraints for email highlight (use same multiplier as password, e.g., 0.075)
        NSLayoutConstraint.activate([
            emailHighlightView.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            emailHighlightView.topAnchor.constraint(equalTo: emailTextField.topAnchor),
            emailHighlightView.bottomAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailHighlightView.widthAnchor.constraint(equalTo: emailTextField.widthAnchor, multiplier: 0.075)
        ])

        // Optional: If you want the shape layer to handle rounding, set cornerRadius to 0
        // emailHighlightView.layer.cornerRadius = 0

        emailTextField.addTarget(self, action: #selector(emailFieldDidBeginEditing), for: .editingDidBegin)
        emailTextField.addTarget(self, action: #selector(emailFieldDidEndEditing), for: .editingDidEnd)
    }

    private func updateEmailHighlightShape() {
        // Clear any old layers
        emailHighlightView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        // Use emailHighlightView's own bounds
        let path = UIBezierPath(
            roundedRect: emailHighlightView.bounds,
            byRoundingCorners: [.topLeft, .bottomLeft],
            cornerRadii: CGSize(width: emailTextField.layer.cornerRadius, height: emailTextField.layer.cornerRadius)
        )

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor(hex: "#85B7CA", alpha: 0.23)?.cgColor

        emailHighlightView.layer.addSublayer(shapeLayer)
    }

    @objc private func emailFieldDidBeginEditing() {
        updateEmailHighlightShape() // Draw the shape
        UIView.animate(withDuration: 0.2) {
            self.emailHighlightView.alpha = 1
        }
    }

    @objc private func emailFieldDidEndEditing() {
        UIView.animate(withDuration: 0.2) {
            self.emailHighlightView.alpha = 0
        }
    }


    
    // Blue highlight for password text field
    private let passwordHighlightView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.masksToBounds = true
        view.alpha = 0 // Initially hidden
        return view
    }()

    private func configurePasswordTextField() {
        view.addSubview(passwordTextField)
        passwordTextField.addSubview(passwordHighlightView) // Add highlight view

        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordHighlightView.translatesAutoresizingMaskIntoConstraints = false

        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = Constants.passwordPlaceholder
        passwordTextField.layer.borderWidth = Constants.borderFieldWidth
        passwordTextField.layer.borderColor = UIColor(hex: "000000", alpha: 0.2)?.cgColor
        passwordTextField.layer.cornerRadius = Constants.fieldRaduis
        passwordTextField.font = UIFont(name: Constants.fontName, size: Constants.fontTextFieldsSize)
        passwordTextField.textColor = UIColor(hex: "000000", alpha: 0.62)

        // Add left padding (same logic as email field)
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.paddingViewWidth + 20, height: passwordTextField.frame.height))
        passwordTextField.leftView = leftPaddingView
        passwordTextField.leftViewMode = .always

        passwordTextField.setHeight(Constants.textFieldHeight)
        passwordTextField.pinLeft(to: view, Constants.padding)
        passwordTextField.pinRight(to: view, Constants.padding)
        passwordTextField.pinTop(to: emailTextField.bottomAnchor, Constants.passwordTextFieldTop)

        // 🔹 Constraints for blue highlight
        NSLayoutConstraint.activate([
            passwordHighlightView.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            passwordHighlightView.topAnchor.constraint(equalTo: passwordTextField.topAnchor),
            passwordHighlightView.bottomAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            passwordHighlightView.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor, multiplier: 0.075) // Adjust width if needed
        ])

        passwordTextField.addTarget(self, action: #selector(passwordFieldDidBeginEditing), for: .editingDidBegin)
        passwordTextField.addTarget(self, action: #selector(passwordFieldDidEndEditing), for: .editingDidEnd)
    }

    // Update the shape of the password highlight
    private func updatePasswordHighlightShape() {
        passwordHighlightView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
  

        let path = UIBezierPath(
            roundedRect: passwordHighlightView.bounds,
            byRoundingCorners: [.topLeft, .bottomLeft],
            cornerRadii: CGSize(width: passwordTextField.layer.cornerRadius, height: passwordTextField.layer.cornerRadius)
        )

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor(hex: "#85B7CA", alpha: 0.23)?.cgColor

        passwordHighlightView.layer.addSublayer(shapeLayer)
    }
    
    private func configureForgetPasswordButton() {
        view.addSubview(forgetPasswordButton)
        forgetPasswordButton.setTitle(Constants.forgetPasswordButtonTitle, for: .normal)
        forgetPasswordButton.setTitleColor(UIColor(hex: "000000", alpha: 0.28), for: .normal)
        forgetPasswordButton.titleLabel?.font = UIFont(name: Constants.fontName, size: Constants.forgetPasswordButtonSize)
        
        forgetPasswordButton.pinTop(to: passwordTextField.bottomAnchor, Constants.forgetPasswordButtonTop)
        forgetPasswordButton.pinRight(to: passwordTextField)
        forgetPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
    }
    
    private func cofigureRememberMe() {
        
    }
    
    private func configureSignUpButton() {
        view.addSubview(signUpButton)
        
        let signUpColor = UIColor(hex: "#94CA85", alpha: 0.4)
        signUpButton.backgroundColor = signUpColor
        signUpButton.tintColor = .black
        
        if let titleColor = UIColor(hex: "000000", alpha: 0.6) {
            signUpButton.setTitleColor(titleColor, for: .normal)
        }
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: Constants.fontName, size: 16.6)
        
        signUpButton.pinTop(to: forgetPasswordButton.bottomAnchor, 41)
        signUpButton.pinRight(to: forgetPasswordButton.trailingAnchor)
        
        signUpButton.setHeight(42)
        signUpButton.setWidth(139)
        signUpButton.layer.cornerRadius = 14
        
        // Add border
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = signUpColor?.withAlphaComponent(0.1).cgColor
        
        // Add shadow
        signUpButton.layer.shadowColor = signUpColor?.cgColor
        signUpButton.layer.shadowOpacity = 0.8
        signUpButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        signUpButton.layer.shadowRadius = 5
        
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
    }

    private func configureLoginButton() {
        view.addSubview(loginButton)
        
        let loginColor = UIColor(hex: "D6C69E", alpha: 0.35)
        loginButton.backgroundColor = loginColor
        loginButton.tintColor = .black
        
        if let titleColor = UIColor(hex: "000000", alpha: 0.6) {
            loginButton.setTitleColor(titleColor, for: .normal)
        }
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: Constants.fontName, size: 16.6)
        
        loginButton.pinLeft(to: passwordTextField.leadingAnchor)
        loginButton.pinTop(to: signUpButton.topAnchor)
        
        loginButton.setHeight(42)
        loginButton.setWidth(139)
        loginButton.layer.cornerRadius = 14
        
        // Add border
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = loginColor?.withAlphaComponent(0.1).cgColor
        
        // Add shadow
        loginButton.layer.shadowColor = loginColor?.cgColor
        loginButton.layer.shadowOpacity = 0.8
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        loginButton.layer.shadowRadius = 5
        
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // Hiding title lable
        UIView.animate(withDuration: 0.3) {
            self.firstLabel.alpha = 0
            self.secondLabel.alpha = 0
            self.thirdLabel.alpha = 0
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
            self.firstLabel.alpha = 1
            self.secondLabel.alpha = 1
            self.thirdLabel.alpha = 1
        }
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    @objc private func forgotPasswordButtonTapped() {
        let forgotVC = ForgotScreenAssembly.assemble()
        navigationController?.pushViewController(forgotVC, animated: true)
    }
    @objc private func presentforgotpassscreen() {
        
        forgotPasswordButtonTapped()
    }
    

    // Show the blue highlight when password field is focused
    @objc private func passwordFieldDidBeginEditing() {
        updatePasswordHighlightShape() // Ensure shape is correct before animating
        UIView.animate(withDuration: 0.2) {
            self.passwordHighlightView.alpha = 1
        }
    }
    

    // Hide the blue highlight when password field loses focus
    @objc private func passwordFieldDidEndEditing() {
        UIView.animate(withDuration: 0.2) {
            self.passwordHighlightView.alpha = 0
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func signUpButtonPressed() {
        interactor?.handleSignUpButtonTapped()
    }
    
    @objc private func loginButtonPressed() {
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        
        interactor?.handleLoginButtonTapped(emailText: emailTextField.text, passwordText: passwordTextField.text)
    }
}


//
//#Preview {
//    return UINavigationController(
//        rootViewController: WelcomeViewController()
//    )
//}
