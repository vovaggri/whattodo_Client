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
        let signUpService = SignUpService()
        let interactor = SignUpInteractor(signUpService: signUpService, presenter: presenter)

        view.interactor = interactor
        presenter.view = view

        return view
    }
}
