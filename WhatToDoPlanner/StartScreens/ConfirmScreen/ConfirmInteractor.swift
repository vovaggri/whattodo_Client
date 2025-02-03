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
    weak var presenter: ConfirmPresenterProtocol?
    
    func verifyCode(_ code: String) {
        // MARK: - Need to fix for real realisation
        // Imitation of code
        let isValid = code == "2323"
        let response = ConfirmScreen.ScreenMessage.Response(message: isValid ? "Verification successful!" : "Invalid code!")
        
        presenter?.presentVerificationResult(response)
    }
}
