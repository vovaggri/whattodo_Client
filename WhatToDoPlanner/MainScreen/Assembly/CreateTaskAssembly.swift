//
//  CreateGoalAssembly.swift
//  WhatToDoPlanner

enum CreateTaskAssembly {
    static func assembly(delegate: CreateTaskViewControllerDelegate?) -> CreateTaskViewController {
        let vc = CreateTaskViewController()
        // Let’s assume you have a presenter & interactor, etc.
        let presenter = CreateTaskPresenter()
        let worker = CreateTaskWorker()
        let interactor = CreateTaskInteractor(presenter: presenter, worker: worker)
        presenter.createTaskVC = vc
        vc.interactor = interactor
        
        // IMPORTANT: set the delegate
        vc.delegate = delegate
        
        return vc
    }
}


