//
//  WelcomePresenter.swift
//  WhatToDo Planner
//
//  Created by Vladimir Grigoryev on 15.01.2025.
//

final class WelcomePresenter: WelcomeInteractorOutput {
    var welcomeVC: WelcomeViewController?
    var router: WelcomeRouterProtocol?
    
    func navigateToSignUpScreen() {
        print("Presenter sign up button works")
        router?.navigateToSignUpScreen()
    }
    
    func showErrorAlert(_ message: String?) {
        welcomeVC?.showError(message: message ?? "Error")
    }
}
