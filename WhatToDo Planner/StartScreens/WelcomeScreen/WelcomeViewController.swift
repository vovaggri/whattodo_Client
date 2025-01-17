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
        static let fieldRaduis: CGFloat = 4
        static let borderFieldWidth: CGFloat = 1
        static let heightField: Double = 50
        static let paddingViewWidth: CGFloat = 10
        static let padding: CGFloat = 49
        
        static let fontTextFieldsLabelSize: CGFloat = 15
        static let fontTextFieldsSize: CGFloat = 19
        
        static let emailLabelText: String = "Email adress"
        static let emailPlaceholder: String = "Enter your email adress"
        static let emailLabelLeft: Double = 49
        static let emailLabelTop: Double = 30
        
        static let passwordLabelText: String = "Password"
        static let passwordPlaceholder: String = "Enter your password"
        static let passwordLabelLeft: Double = 49
        static let passwordLabelTop: Double = 20
        
        // Forget password button
        static let forgetPasswordButtonTitle: String = "Forget password?"
        static let forgetPasswordButtonSize: CGFloat = 12
        static let forgetPasswordButtonTop: Double = 18
    }
    
    // MARK: - Variables
    var interactor: WelcomeInteractor?
    var router: WelcomeRouter?
    
    private let firstLabel: UILabel = UILabel()
    private let secondLabel: UILabel = UILabel()
    private let thirdLabel: UILabel = UILabel()
    
    private let emailLabel: UILabel = UILabel()
    private let passwordLabel: UILabel = UILabel()
    private let emailTextField: UITextField = UITextField()
    private let passwordTextField: UITextField = UITextField()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(hex: "#94CA85", alpha: 0.4)
        button.tintColor = .black
        
        if let titleColor = UIColor(hex: "000000", alpha: 0.6) {
            button.setTitleColor(titleColor, for: .normal)
        }
        
        button.setTitle("Sign Up", for: .normal)
        
        button.titleLabel?.font = UIFont(name: Constants.fontName, size: 14)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
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
    
    private func configureSignUpButton() {
        view.addSubview(signUpButton)
        
        signUpButton.pinCenterX(to: view)
        signUpButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 20)
        signUpButton.setHeight(38)
        signUpButton.setWidth(124)
        signUpButton.layer.cornerRadius = 4
    }
    
    private func configureEmailTextField() {
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        emailLabel.font = UIFont(name: Constants.fontName, size: Constants.fontTextFieldsLabelSize)
        emailLabel.textColor = UIColor(hex: "000000", alpha: 0.4)
        
        emailLabel.text = Constants.emailLabelText
        
        emailLabel.pinLeft(to: view, Constants.emailLabelLeft)
        emailLabel.pinTop(to: thirdLabel.bottomAnchor, Constants.emailLabelTop)
        
        emailTextField.autocapitalizationType = .none
        emailTextField.placeholder = Constants.emailPlaceholder
        emailTextField.layer.borderWidth = Constants.borderFieldWidth
        emailTextField.layer.borderColor = UIColor(hex: "000000", alpha: 0.35)?.cgColor
        emailTextField.layer.cornerRadius = Constants.fieldRaduis
        emailTextField.font = UIFont(name: Constants.fontName, size: Constants.fontTextFieldsSize)
        emailTextField.textColor = UIColor(hex: "000000", alpha: 0.6)
        
        // Добавляем отступ через пустое представление
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.paddingViewWidth, height: emailTextField.frame.height))
        emailTextField.leftView = paddingView
        
        emailTextField.pinLeft(to: view, Constants.padding)
        emailTextField.pinRight(to: view, Constants.padding)
        emailTextField.pinTop(to: emailLabel.bottomAnchor, 10)
        
        emailTextField.leftViewMode = .always
    }
    
    private func configurePasswordTextField() {
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordLabel.font = UIFont(name: Constants.fontName, size: Constants.fontTextFieldsLabelSize)
        passwordLabel.textColor = UIColor(hex: "000000", alpha: 0.4)
        
        passwordLabel.text = Constants.passwordLabelText
        
        passwordLabel.pinLeft(to: view, Constants.passwordLabelLeft)
        passwordLabel.pinTop(to: emailTextField.bottomAnchor, Constants.passwordLabelTop)
        
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = Constants.passwordPlaceholder
        passwordTextField.layer.borderWidth = Constants.borderFieldWidth
        passwordTextField.layer.borderColor = UIColor(hex: "000000", alpha: 0.35)?.cgColor
        passwordTextField.layer.cornerRadius = Constants.fieldRaduis
        passwordTextField.font = UIFont(name: Constants.fontName, size: Constants.fontTextFieldsSize)
        passwordTextField.textColor = UIColor(hex: "000000", alpha: 0.6)
        
        // Добавляем отступ через пустое представление
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.paddingViewWidth, height: emailTextField.frame.height))
        passwordTextField.leftView = paddingView
        passwordTextField.pinLeft(to: view, Constants.padding)
        passwordTextField.pinRight(to: view, Constants.padding)
        passwordTextField.pinTop(to: passwordLabel.bottomAnchor, 10)
        
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

