//
//  ConfirmPresenter.swift
//  WhatToDoPlanner
//
//  Created by Vladimir Grigoryev on 02.02.2025.
//

import Foundation

protocol ConfirmPresenterProtocol: AnyObject{
    func presentVerificationResult(_ response: ConfirmScreen.ScreenMessage.Response)
    func showError(_ message: String)
    func navigateToCongrats()
}

final class ConfirmPresenter: ConfirmPresenterProtocol {
    weak var viewController: ConfirmViewController?

    func presentVerificationResult(_ response: ConfirmScreen.ScreenMessage.Response) {
        let viewModel = ConfirmScreen.ScreenMessage.ViewModel(message: response.message)
        viewController?.displayVerificationResult(viewModel)
    }
    
    func showError(_ message: String) {
        viewController?.displayError(message)
    }
    
    func navigateToCongrats() {
        let congratsVC = SuccessScreenConfigurator.configureModule()
        viewController?.navigationController?.setViewControllers([congratsVC], animated: true)
    }
}
