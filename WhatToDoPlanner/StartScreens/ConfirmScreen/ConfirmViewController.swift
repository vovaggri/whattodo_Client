//
//  ConfirmViewController.swift
//  WhatToDoPlanner
//
//  Created by Vladimir Grigoryev on 02.02.2025.
//

import UIKit

final class ConfirmViewController: UIViewController {
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
        
        static let firstTitleLabelText: String = "Confirm"
        static let secondTitleLabelText: String = "your e-mail"
        
        static let titleLabelSize: CGFloat = 40
        
        static let firstTitleLabelTop: Double = 154
        static let titleLabelLeft: Double = 21
        
        static let secondTitleLabelTop: Double = 60
        
        static let codeFieldSize: CGFloat = 50
        static let codeFieldSpacing: CGFloat = 15
        static let codeFieldTop: CGFloat = 40
        
        static let confirmButtonTitle: String = "Confirm"
        static let confirmButtonHeight: CGFloat = 50
        static let confirmBottonWidth: CGFloat = 364
        static let confirmButtonTop: Double = 123
        static let confirmButtonRadius: CGFloat = 14
    }
    
    private let interactor: ConfirmInteractorProtocol
    private var codeTextFields: [UITextField] = []
    
    private let firstTitleLabel: UILabel = UILabel()
    private let secondTitleLabel: UILabel = UILabel()
    private let confirmButton: UIButton = UIButton(type: .system)
    
    init(interactor: ConfirmInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented (ConfirmViewController)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureTitleLabels()
        configureCodeTextFields()
        configureConfirmButton()
    }
    
    func displayVerificationResult(_ viewModel: ConfirmScreen.ScreenMessage.ViewModel) {
        let alert = UIAlertController(title: "Success", message: viewModel.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func configureTitleLabels() {
        view.addSubview(firstTitleLabel)
        view.addSubview(secondTitleLabel)
        
        firstTitleLabel.text = Constants.firstTitleLabelText
        firstTitleLabel.font = UIFont(name: Constants.fontName, size: Constants.titleLabelSize)
        firstTitleLabel.textColor = .black
        firstTitleLabel.pinTop(to: view, Constants.firstTitleLabelTop)
        firstTitleLabel.pinLeft(to: view, Constants.titleLabelLeft)
        
        secondTitleLabel.text = Constants.secondTitleLabelText
        secondTitleLabel.font = UIFont(name: Constants.fontName, size: Constants.titleLabelSize)
        secondTitleLabel.textColor = .black
        secondTitleLabel.pinTop(to: firstTitleLabel, Constants.secondTitleLabelTop)
        secondTitleLabel.pinLeft(to: view, Constants.titleLabelLeft)
    }
    
    private func configureCodeTextFields() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.codeFieldSpacing
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        for _ in 0..<4 {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.textAlignment = .center
            textField.font = UIFont(name: Constants.fontName, size: 24)
            textField.keyboardType = .numberPad
            textField.delegate = self
            textField.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(textField)
            codeTextFields.append(textField)
        }
        
        stackView.pinTop(to: secondTitleLabel.bottomAnchor, Constants.codeFieldTop)
        stackView.pinCenterX(to: view.centerXAnchor)
        stackView.setHeight(Constants.codeFieldSize)
        stackView.setWidth((Constants.codeFieldSize * 4) + (Constants.codeFieldSpacing * 3))
    }
    
    private func configureConfirmButton() {
        view.addSubview(confirmButton)
        
        confirmButton.setTitle(Constants.confirmButtonTitle, for: .normal)
        confirmButton.setTitleColor(UIColor(hex: "000000", alpha: 0.6), for: .normal)
        confirmButton.backgroundColor = UIColor(hex: "94CA85", alpha: 0.35)
        confirmButton.layer.cornerRadius = Constants.confirmButtonRadius
        confirmButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        if let lastTextField = codeTextFields.last {
            confirmButton.pinTop(to: lastTextField.bottomAnchor, Constants.confirmButtonTop)
            confirmButton.pinCenterX(to: view.centerXAnchor)
            confirmButton.setWidth(Constants.confirmBottonWidth)
            confirmButton.setHeight(Constants.confirmButtonHeight)
        }
    }
    
    @objc private func confirmButtonPressed() {
        let code = codeTextFields.compactMap { $0.text }.joined()
        guard code.count == 4 else {
            displayError("Please enter a valid 4-digit code.")
            return
        }
        interactor.verifyCode(code)
    }
}

extension ConfirmViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text, let textRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        
        if updatedText.count > 1 {
            return false
        }
        
        textField.text = updatedText
        
        // If user enter a digit, it will switch to next field
        if !string.isEmpty {
            if let index = codeTextFields.firstIndex(of: textField), index < 3 {
                codeTextFields[index + 1].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        } else {
            // If user delete a symbol, it will switch back
            if let index = codeTextFields.firstIndex(of: textField), index > 0 {
                codeTextFields[index - 1].becomeFirstResponder()
            }
        }
        
        return false
    }
}
