//
//  WelcomeInteractor.swift
//  WhatToDo Planner
//
//  Created by Vladimir Grigoryev on 15.01.2025.
//

import Foundation

protocol WelcomeBusinessLogic {
    func handleSignUpButtonTapped()
    func handleLoginButtonTapped(email emailText: String?, password passwordText: String?)
}

protocol WelcomeInteractorOutput: AnyObject {
    func navigateToSignUpScreen()
    func showErrorAlert(_ message: String?)
}

final class WelcomeInteractor: WelcomeBusinessLogic {
    var presenter: WelcomeInteractorOutput?
    
    func handleSignUpButtonTapped() {
        print("Interactor Sign up button works")
        presenter?.navigateToSignUpScreen()
    }
    
    func handleLoginButtonTapped(email emailText: String?, password passwordText: String?) {
        if (emailText == "" || passwordText == "") {
            presenter?.showErrorAlert("There's empty necessary fields! Please, try again.")
        } else if (!isEmailCorrect(emailText)) {
            presenter?.showErrorAlert("Email is incorrect! Please, try again.")
        }
    }
    
    private func isEmailCorrect(_ email: String?) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
 
