//
//  WelcomePresenter.swift
//  WhatToDo Planner
//
//  Created by Vladimir Grigoryev on 15.01.2025.
//

final class WelcomePresenter: WelcomeInteractorOutput {
    weak var welcomeVC: WelcomeViewController?
    var router: WelcomeRouterProtocol?
    
    func navigateToSignUpScreen() {
        router?.navigateToSignUpScreen()
    }
}
