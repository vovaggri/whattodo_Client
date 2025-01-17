//
//  WelcomeAssembly.swift
//  WhatToDo Planner
//
//  Created by Vladimir Grigoryev on 16.01.2025.
//

import UIKit

final class WelcomeModuleAssembly {
    static func assembly() -> UIViewController {
        let viewController = WelcomeViewController()
        let interactor = WelcomeInteractor()
        let presenter = WelcomePresenter()
        let router = WelcomeRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        presenter.router = router
        presenter.welcomeVC = viewController
        
        router.welcomeVC = viewController
        
        return viewController
    }
}
