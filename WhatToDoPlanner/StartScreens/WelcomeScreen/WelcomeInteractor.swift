//
//  WelcomeInteractor.swift
//  WhatToDo Planner
//
//  Created by Vladimir Grigoryev on 15.01.2025.
//

import Foundation

protocol WelcomeBusinessLogic {
    func handleSignUpButtonTapped()
    func handleLoginButtonTapped(emailText: String?, passwordText: String?)
}

protocol WelcomeInteractorOutput: AnyObject {
    func navigateToSignUpScreen()
    func showErrorAlert(_ message: String?)
}

final class WelcomeInteractor: WelcomeBusinessLogic {
    var presenter: WelcomeInteractorOutput?
    private let worker: WelcomeWorkerProtocol
    
    init(presenter: WelcomeInteractorOutput?, worker: WelcomeWorkerProtocol) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func handleSignUpButtonTapped() {
        print("Interactor Sign up button works")
        presenter?.navigateToSignUpScreen()
    }
    
    func handleLoginButtonTapped(emailText: String?, passwordText: String?) {
        guard let email = emailText, !email.isEmpty,
              let password = passwordText, !password.isEmpty else {
            presenter?.showErrorAlert("All fields are required.")
            return
        }
        
        let user: WelcomeModels.User = WelcomeModels.User(email: email, password: password)
        validateAndSignIn(user: user)
    }
    
    private func isEmailCorrect(_ email: String?) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func validateAndSignIn(user: WelcomeModels.User) {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let isEmailValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: user.email)
        
        guard isEmailValid else {
            presenter?.showErrorAlert("Invalid email or password.")
            return
        }
        
        worker.signIn(user: user) { [weak self] result in
            switch result {
            case.success:
                print("Self in closure: \(String(describing: self))")
                print("Done")
            case.failure(let error):
                self?.presenter?.showErrorAlert(error.localizedDescription)
            }
            
        }
    }
}
 
