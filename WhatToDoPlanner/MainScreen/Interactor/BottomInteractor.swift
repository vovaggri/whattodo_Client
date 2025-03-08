//
//  BottomInteractor.swift
//  WhatToDoPlanner

import UIKit

protocol BottomBusinessLogic {
    func switcherPressed()
    func detentChanged(newDetent: UISheetPresentationController.Detent.Identifier?)
}

final class BottomInteractor: BottomBusinessLogic {
    private var presenter: BottomPresentationLogic?
    
    init(presenter: BottomPresentationLogic?) {
        self.presenter = presenter
    }
    
    func switcherPressed() {
        presenter?.switchMode()
    }
    
    func detentChanged(newDetent: UISheetPresentationController.Detent.Identifier?) {
        let isLarge = newDetent == .large
        presenter?.updateMode(isLarge: isLarge)
    }
}
