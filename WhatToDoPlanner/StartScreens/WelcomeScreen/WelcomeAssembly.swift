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
        
        viewController.interactor = interactor
        
        interactor.presenter = presenter
        presenter.welcomeVC = viewController
        
        return viewController
    }
}
