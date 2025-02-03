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
    weak var viewController: ConfirmViewControllerProtocol?

    func presentVerificationResult(_ response: ConfirmScreen.ScreenMessage.Response) {
        let viewModel = ConfirmScreen.ScreenMessage.ViewModel(message: response.message)
        viewController?.displayConfirmationResult(viewModel)
    }
}
