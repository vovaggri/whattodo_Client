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
        static let fontTextFieldsSize: CGFloat = 14
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
    }
    
    // MARK: - Variables
    var interactor: WelcomeBusinessLogic?
    var router: WelcomeRouterProtocol?
    
    private let firstLabel: UILabel = UILabel()
    private let secondLabel: UILabel = UILabel()
    private let thirdLabel: UILabel = UILabel()
    
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
    
     
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
    private let descriptionLabel: UILabel = UILabel()

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
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        
    }

    private let emailHighlightView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear // We'll use a shape layer for the exact design
        view.layer.masksToBounds = true
        view.alpha = 0 // Initially hidden
        return view
    }()


    private func configureEmailTextField() {
        view.addSubview(emailTextField)
        emailTextField.addSubview(emailHighlightView)

        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailHighlightView.translatesAutoresizingMaskIntoConstraints = false

        // Configure emailTextField properties
        emailTextField.autocapitalizationType = .none
        emailTextField.placeholder = Constants.emailPlaceholder
        emailTextField.layer.borderWidth = Constants.borderFieldWidth
        emailTextField.layer.borderColor = UIColor(hex: "000000", alpha: 0.15)?.cgColor
        emailTextField.layer.cornerRadius = 14
        //emailTextField.font = UIFont(name: Constants.fontName, size: Constants.fontTextFieldsSize)
        emailTextField.textColor = UIColor(hex: "000000", alpha: 0.3)
        emailTextField.leftViewMode = .always

        emailTextField.setHeight(Constants.textFieldHeight)
        emailTextField.pinLeft(to: view, Constants.padding)
        emailTextField.pinRight(to: view, Constants.padding)
        emailTextField.pinTop(to: thirdLabel.bottomAnchor, Constants.emailTextFieldTop)

        NSLayoutConstraint.activate([
            emailHighlightView.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            emailHighlightView.topAnchor.constraint(equalTo: emailTextField.topAnchor),
            emailHighlightView.bottomAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailHighlightView.widthAnchor.constraint(equalTo: emailTextField.widthAnchor, multiplier: 0.15) // Adjust as needed
        ])




        // Add event listeners
        emailTextField.addTarget(self, action: #selector(emailFieldDidBeginEditing), for: .editingDidBegin)
        emailTextField.addTarget(self, action: #selector(emailFieldDidEndEditing), for: .editingDidEnd)
    }

    private func updateHighlightShape() {
        let height = emailHighlightView.bounds.height
        let width = emailHighlightView.bounds.width
        let cornerRadius = emailTextField.layer.cornerRadius

        let path = UIBezierPath()

        // Start at the bottom-left corner
        path.move(to: CGPoint(x: 0, y: height - cornerRadius))
        
        // Bottom-left semicircle curve
        path.addArc(
            withCenter: CGPoint(x: cornerRadius, y: height - cornerRadius),
            radius: cornerRadius,
            startAngle: .pi,
            endAngle: .pi / 2,
            clockwise: false
        )

        // Move up to the top-left semicircle curve
        path.addLine(to: CGPoint(x: cornerRadius, y: cornerRadius))

        // Top-left semicircle curve
        path.addArc(
            withCenter: CGPoint(x: cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: .pi / 2,
            endAngle: 0,
            clockwise: false
        )

        // Draw a straight vertical line on the right (ensuring full fill-in)
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))

        // Close the path
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor(hex: "#85B7CA", alpha: 0.45)?.cgColor

        emailHighlightView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        emailHighlightView.layer.addSublayer(shapeLayer)
    }


    @objc private func emailFieldDidBeginEditing() {
        UIView.animate(withDuration: 0.2) {
            self.emailHighlightView.alpha = 1
            self.updateHighlightShape()
        }
    }

    @objc private func emailFieldDidEndEditing() {
        UIView.animate(withDuration: 0.2) {
            self.emailHighlightView.alpha = 0
        }
    }











    
    private func configurePasswordTextField() {
//        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        
//        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
//        passwordLabel.font = UIFont(name: Constants.fontName, size: Constants.fontTextFieldsLabelSize)
//        passwordLabel.textColor = UIColor(hex: "000000", alpha: 0.4)
//        
//        passwordLabel.text = Constants.passwordLabelText
//        
//        passwordLabel.pinLeft(to: view, Constants.passwordLabelLeft)
//        passwordLabel.pinTop(to: emailTextField.bottomAnchor, Constants.passwordLabelTop)
        
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = Constants.passwordPlaceholder
        passwordTextField.layer.borderWidth = Constants.borderFieldWidth
        passwordTextField.layer.borderColor = UIColor(hex: "000000", alpha: 0.4)?.cgColor
        passwordTextField.layer.cornerRadius = Constants.fieldRaduis
        passwordTextField.font = UIFont(name: Constants.fontName, size: Constants.fontTextFieldsSize)
        passwordTextField.textColor = UIColor(hex: "000000", alpha: 0.3)
       // passwordTextField.layer.cornerRadius = Constants.textFieldCornerRadius
        
        
        // Добавляем отступ через пустое представление
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.paddingViewWidth, height: emailTextField.frame.height))
        passwordTextField.leftView = paddingView
        
        passwordTextField.setHeight(Constants.textFieldHeight)
        
        passwordTextField.pinLeft(to: view, Constants.padding)
        passwordTextField.pinRight(to: view, Constants.padding)
        passwordTextField.pinTop(to: emailTextField.bottomAnchor, Constants.passwordTextFieldTop)
        
        passwordTextField.leftViewMode = .always
    }
    
    private func configureForgetPasswordButton() {
        view.addSubview(forgetPasswordButton)
        forgetPasswordButton.setTitle(Constants.forgetPasswordButtonTitle, for: .normal)
        forgetPasswordButton.setTitleColor(UIColor(hex: "000000", alpha: 0.28), for: .normal)
        forgetPasswordButton.titleLabel?.font = UIFont(name: Constants.fontName, size: Constants.forgetPasswordButtonSize)
        
        forgetPasswordButton.pinTop(to: passwordTextField.bottomAnchor, Constants.forgetPasswordButtonTop)
        forgetPasswordButton.pinRight(to: passwordTextField)
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
        signUpButton.titleLabel?.font = UIFont(name: Constants.fontName, size: 14)
        
        signUpButton.pinTop(to: forgetPasswordButton.bottomAnchor, 41)
        signUpButton.pinRight(to: forgetPasswordButton.trailingAnchor)
        
        signUpButton.setHeight(38)
        signUpButton.setWidth(124)
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
        loginButton.titleLabel?.font = UIFont(name: Constants.fontName, size: 14)
        
        loginButton.pinLeft(to: passwordTextField.leadingAnchor)
        loginButton.pinTop(to: signUpButton.topAnchor)
        
        loginButton.setHeight(38)
        loginButton.setWidth(124)
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

    
    // MARK: - Objc private methods
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func signUpButtonPressed() {
        interactor?.handleSignUpButtonTapped()
    }
    
    @objc private func loginButtonPressed() {
        interactor?.handleLoginButtonTapped(email: emailTextField.text, password: passwordTextField.text)
    }
}

