//
//  PinCodePresenter.swift
//  WhatToDoPlanner
//
//  Created by Vladimir Grigoryev on 02.02.2025.
//

import Foundation

protocol PinCodePresenterProtocol: AnyObject{
    func presentVerificationResult(_ response: PinCodeScreen.ScreenMessage.Response)
    func navigateToPassword(_ email: String)
    func showError(_ message: String)
}

final class PinCodePresenter: PinCodePresenterProtocol {
    weak var viewController: PinCodeViewController?

    func presentVerificationResult(_ response: PinCodeScreen.ScreenMessage.Response) {
        let viewModel = PinCodeScreen.ScreenMessage.ViewModel(message: response.message)
        viewController?.displayVerificationResult(viewModel)
    }
    
    func navigateToPassword(_ email: String) {
        let changePasswordVC = ChangePasswordAssembly.assemble(email: email)
        viewController?.navigationController?.setViewControllers([changePasswordVC], animated: true)
    }
    
    func showError(_ message: String) {
        viewController?.returnConfirmButton()
        viewController?.displayError(message)
    }
}
