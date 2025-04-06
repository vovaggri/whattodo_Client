//
//  ConfirmAssembly.swift
//  WhatToDoPlanner
//
//  Created by Vladimir Grigoryev on 02.02.2025.
//

import UIKit

final class ConfirmModuleAssembly {
    static func assembly(email: String) -> UIViewController {
        let presenter = ConfirmPresenter()
        let worker = ConfirmWorker()
        let interactor = ConfirmInteractor(presenter: presenter, worker: worker, email: email)
        let viewController = ConfirmViewController(interactor: interactor)
       
        presenter.viewController = viewController
        
        return viewController
    }
}
