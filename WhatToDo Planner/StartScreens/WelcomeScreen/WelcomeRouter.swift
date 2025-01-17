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
    weak var welcomeVC: UIViewController?
    
    func navigateToSignUpScreen() {
        
    }
}
