//
//  WelcomeInteractor.swift
//  WhatToDo Planner
//
//  Created by Vladimir Grigoryev on 15.01.2025.
//

protocol WelcomeBusinessLogic {
    func handleSignUpButtonTapped()
}

protocol WelcomeInteractorOutput: AnyObject {
    func navigateToSignUpScreen()
}

final class WelcomeInteractor: WelcomeBusinessLogic {
    var presenter: WelcomeInteractorOutput?
    
    func handleSignUpButtonTapped() {
        print("Interactor works")
        presenter?.navigateToSignUpScreen()
    }
}
 
