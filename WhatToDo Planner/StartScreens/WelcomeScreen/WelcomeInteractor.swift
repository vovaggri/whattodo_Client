//
//  WelcomeInteractor.swift
//  WhatToDo Planner
//
//  Created by Vladimir Grigoryev on 15.01.2025.
//

protocol WelcomeBusinessLogic {
    func handleSignInButtonTapped()
}

protocol WelcomeInteractorOutput: AnyObject {
    func navigateToSignUpScreen()
}

final class WelcomeInteractor: WelcomeBusinessLogic {
    weak var presenter: WelcomeInteractorOutput?
    
    func handleSignInButtonTapped() {
        presenter?.navigateToSignUpScreen()
    }
}
