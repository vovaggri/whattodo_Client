//
//  PinCodeInteractor.swift
//  WhatToDoPlanner
//
//  Created by Vladimir Grigoryev on 02.02.2025.
//

import Foundation

protocol PinCodeInteractorProtocol: AnyObject {
    func verifyCode(_ code: String, email: String)
}

final class PinCodeInteractor: PinCodeInteractorProtocol {
    var presenter: PinCodePresenterProtocol?
    var worker: PinCodeWorkerProtocol?
    
    func verifyCode(_ code: String, email: String) {
//        // MARK: - Need to fix for real realization
//        // Imitation of code
//        let isValid = code == "2323"
//        let response = PinCodeScreen.ScreenMessage.Response(message: isValid ? "Verification successful!" : "Invalid code!")
//        
//        presenter?.presentVerificationResult(response)
        
        let user: ConfirmScreen.UserConfirmRequest = ConfirmScreen.UserConfirmRequest(email: email, code: code)
        
        worker?.sendCode(user) { [weak self] result in
            switch result {
            case.success:
                print("Self in closure: \(String(describing: self))")
                print("Done")
                self?.presenter?.navigateToPassword(email)
            case.failure(let error):
                self?.presenter?.showError(error.localizedDescription)
            }
        }
    }
}
