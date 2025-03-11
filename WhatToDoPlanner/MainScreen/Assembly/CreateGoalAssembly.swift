//
//  CreateGoalAssembly.swift
//  WhatToDoPlanner

final class CreateGoalAssembly {
    static func assembly() -> CreateGoalViewController {
        let viewController = CreateGoalViewController()
        let presenter = CreateGoalPresenter()
        let interactor = CreateGoalInteractor(presenter: presenter)
        
        viewController.interactor = interactor
        presenter.creatGoalVC = viewController
        
        return viewController
    }
}

