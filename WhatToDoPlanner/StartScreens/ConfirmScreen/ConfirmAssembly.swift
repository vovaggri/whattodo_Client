//
//  ConfirmAssembly.swift
//  WhatToDoPlanner
//
//  Created by Vladimir Grigoryev on 02.02.2025.
//

import UIKit

final class ConfirmModuleAssembly {
    static func assembly() -> UIViewController {
        let presenter = ConfirmPresenter()
        let worker = ConfirmWorker()
        let interactor = ConfirmInteractor(presenter: presenter, worker: worker)
        let viewController = ConfirmViewController(interactor: interactor)
       
        presenter.viewController = viewController
        
        return viewController
    }
}
