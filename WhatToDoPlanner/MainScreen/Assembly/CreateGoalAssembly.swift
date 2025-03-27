//
//  CreateGoalAssembly.swift
//  WhatToDoPlanner

enum CreateGoalAssembly {
    static func assembly(delegate: CreateGoalViewControllerDelegate?) -> CreateGoalViewController {
        let vc = CreateGoalViewController()
        // Let’s assume you have a presenter & interactor, etc.
        let presenter = CreateGoalPresenter()
        let interactor = CreateGoalInteractor(presenter: presenter)
        presenter.creatGoalVC = vc
        vc.interactor = interactor
        
        // IMPORTANT: set the delegate
        vc.delegate = delegate
        
        return vc
    }
}


