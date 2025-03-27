//
//  ConfirmPresenter.swift
//  WhatToDoPlanner
//
//  Created by Vladimir Grigoryev on 02.02.2025.
//

import Foundation

protocol ConfirmPresenterProtocol: AnyObject{
    func presentVerificationResult(_ response: ConfirmScreen.ScreenMessage.Response)
}

final class ConfirmPresenter: ConfirmPresenterProtocol {
    weak var viewController: ConfirmViewController?

    func presentVerificationResult(_ response: ConfirmScreen.ScreenMessage.Response) {
        if response.message == "Invalid code!" {
            let viewModel = ConfirmScreen.ScreenMessage.ViewModel(message: response.message)
            viewController?.displayVerificationResult(viewModel)
        } else {
            let mainVC = MainAssembly.assembly()
            viewController?.navigationController?.setViewControllers([mainVC], animated: true)
        }
    }
}
