//
//  CreateGoalPreaenter.swift
//  WhatToDoPlanner

protocol CreateTaskPresenterProtocol {
    func showErrorAlert(_ message: String?)
    func navigateMainScreen()
    func showGoals(with goals: [Goal])
}

final class CreateTaskPresenter: CreateTaskPresenterProtocol {
    weak var createTaskVC: CreateTaskViewController?
    
    func showErrorAlert(_ message: String?) {
        createTaskVC?.showError(message: message ?? "Error")
    }
    
    func navigateMainScreen() {
        createTaskVC?.navigationController?.popViewController(animated: true)
    }
    
    func showGoals(with goals: [Goal]) {
        createTaskVC?.showGoals(with: goals)
    }
}
