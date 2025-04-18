//
//  CreateGoalAssembly.swift
//  WhatToDoPlanner


//
final class CreateGTaskAssembly {
    static func assembly(with goalId: Int) -> CreateGTaskViewController {
        let viewController = CreateGTaskViewController()
        let presenter = CreateGTaskPresenter()
        let worker = CreateGTaskWorker()
        let interactor = CreateGTaskInteractor(presenter: presenter, worker: worker)
        
        viewController.interactor = interactor
        viewController.goalId = goalId
        presenter.viewController = viewController
        
        return viewController
    }
}




