//
//  BottomInteractor.swift
//  WhatToDoPlanner

protocol BottomBusinessLogic {
    func switcherPressed()
}

final class BottomInteractor: BottomBusinessLogic {
    private var presenter: BottomPresentationLogic?
    
    init(presenter: BottomPresentationLogic?) {
        self.presenter = presenter
    }
    
    func switcherPressed() {
        presenter?.switchMode()
    }
}
