//
//  SignUpModuleBuilder.swift
//  WhatToDoPlanner
//
//  Created by MACBOOK PRO M1 on 21.1.25.
//

import UIKit


final class SignUpModuleBuilder {
    static func build() -> UIViewController {
        let view = SignUpViewController()
        let presenter = SignUpPresenter()
        let interactor = SignUpInteractor()
        let router = SignUpRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.viewController = view

        return view
    }
}
