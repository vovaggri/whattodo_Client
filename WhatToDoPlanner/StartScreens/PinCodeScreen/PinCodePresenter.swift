//
//  PinCodePresenter.swift
//  WhatToDoPlanner
//
//  Created by Vladimir Grigoryev on 02.02.2025.
//

import Foundation

protocol PinCodePresenterProtocol: AnyObject{
    func presentVerificationResult(_ response: PinCodeScreen.ScreenMessage.Response)
}

final class PinCodePresenter: PinCodePresenterProtocol {
    weak var viewController: PinCodeViewController?

    func presentVerificationResult(_ response: PinCodeScreen.ScreenMessage.Response) {
        let viewModel = PinCodeScreen.ScreenMessage.ViewModel(message: response.message)
        viewController?.displayVerificationResult(viewModel)
    }
}
