//
//  WelcomePresenter.swift
//  WhatToDo Planner
//
//  Created by Vladimir Grigoryev on 15.01.2025.
//

final class WelcomePresenter: WelcomeInteractorOutput {
    weak var welcomeVC: WelcomeViewController?
    
    func navigateToSignUpScreen() {
        print("Presenter works")
        
        // Debugging logs
        print("welcomeVC: \(String(describing: welcomeVC))") // Check if welcomeVC is properly initialized
        print("navigationController: \(String(describing: welcomeVC?.navigationController))") // Check if navigationController is available
        
        // Ensure welcomeVC is not nil and has a navigationController
        guard let navigationController = welcomeVC?.navigationController else {
            print("Error: navigationController is nil. Ensure WelcomeViewController is embedded in a UINavigationController.")
            return
        }
        
        // Create the welcome view controller using your assembly
        let welcomeVC = SignUpModuleBuilder.build()
        navigationController.pushViewController(welcomeVC, animated: true)
    }
    
    func showErrorAlert(_ message: String?) {
        welcomeVC?.showError(message: message ?? "Error")
    }
}
