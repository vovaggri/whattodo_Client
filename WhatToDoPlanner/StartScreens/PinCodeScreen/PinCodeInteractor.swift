//
//  PinCodeInteractor.swift
//  WhatToDoPlanner
//
//  Created by Vladimir Grigoryev on 02.02.2025.
//

import Foundation

protocol PinCodeInteractorProtocol: AnyObject {
    func verifyCode(_ code: String)
}

final class PinCodeInteractor: PinCodeInteractorProtocol {
    var presenter: PinCodePresenterProtocol?
    
    func verifyCode(_ code: String) {
        // MARK: - Need to fix for real realization
        // Imitation of code
        let isValid = code == "2323"
        let response = PinCodeScreen.ScreenMessage.Response(message: isValid ? "Verification successful!" : "Invalid code!")
        
        presenter?.presentVerificationResult(response)
    }
}
