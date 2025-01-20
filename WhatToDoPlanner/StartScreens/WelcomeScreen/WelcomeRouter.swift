//
//  WelcomeRouter.swift
//  WhatToDo Planner
//
//  Created by Vladimir Grigoryev on 15.01.2025.
//

import UIKit

protocol WelcomeRouterProtocol {
    func navigateToSignUpScreen()
}

final class WelcomeRouter: WelcomeRouterProtocol {
    var welcomeVC: UIViewController?
    
    func navigateToSignUpScreen() {
        print("Router works")
        let signUpVC = SignUpViewController()
        welcomeVC?.navigationController?.pushViewController(signUpVC, animated: true)
    }
}
