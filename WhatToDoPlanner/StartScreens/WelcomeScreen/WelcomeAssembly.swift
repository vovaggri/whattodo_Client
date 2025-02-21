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
        let presenter = WelcomePresenter()
        let worker = WelcomeWorker()
        let interactor = WelcomeInteractor(presenter: presenter, worker: worker)
        
        viewController.interactor = interactor
        
        interactor.presenter = presenter
        presenter.welcomeVC = viewController
        
        return viewController
    }
}
