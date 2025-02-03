//
//  ConfirmAssembly.swift
//  WhatToDoPlanner
//
//  Created by Vladimir Grigoryev on 02.02.2025.
//

import UIKit

final class ConfirmModuleAssembly {
    static func assembly() -> UIViewController {
        let interactor = ConfirmInteractor()
        let presenter = ConfirmPresenter()
        let viewController = ConfirmViewController(interactor: interactor)
       
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
