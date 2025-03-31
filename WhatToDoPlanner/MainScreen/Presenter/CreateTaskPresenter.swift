//
//  CreateGoalPreaenter.swift
//  WhatToDoPlanner

protocol CreateTaskPresenterProtocol {
    func showErrorAlert(_ message: String?)
}

final class CreateTaskPresenter: CreateTaskPresenterProtocol {
    weak var createTaskVC: CreateTaskViewController?
    
    func showErrorAlert(_ message: String?) {
        createTaskVC?.showError(message: message ?? "Error")
    }
}
