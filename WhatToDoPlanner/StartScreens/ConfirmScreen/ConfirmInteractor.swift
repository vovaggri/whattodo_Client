//
//  ConfirmInteractor.swift
//  WhatToDoPlanner
//
//  Created by Vladimir Grigoryev on 02.02.2025.
//

import Foundation

protocol ConfirmInteractorProtocol: AnyObject {
    func verifyCode(_ code: String)
}

final class ConfirmInteractor: ConfirmInteractorProtocol {
    private var presenter: ConfirmPresenterProtocol?
    private var worker: ConfirmWorkerProtocol?
    private var email: String?
    
    init(presenter: ConfirmPresenterProtocol?, worker: ConfirmWorkerProtocol?, email: String?) {
        self.presenter = presenter
        self.worker = worker
        self.email = email
    }
    
    func verifyCode(_ code: String) {
        // MARK: - Need to fix for real realization
        guard let email = email else {
            presenter?.showError("Not found email!")
            return
        }
        let user: ConfirmScreen.UserConfirmRequest = ConfirmScreen.UserConfirmRequest(email: email, code: code)
        
        worker?.sendCode(user) { [weak self] result in
            switch result {
            case.success:
                print("Self in closure: \(String(describing: self))")
                print("Done")
                self?.presenter?.navigateToCongrats()
            case.failure(let error):
                self?.presenter?.showError(error.localizedDescription)
            }
        }
        
//        let isValid = code == "2323"
//        let response = ConfirmScreen.ScreenMessage.Response(message: isValid ? "Verification successful!" : "Invalid code!")
//        
//        presenter?.presentVerificationResult(response)
    }
}
