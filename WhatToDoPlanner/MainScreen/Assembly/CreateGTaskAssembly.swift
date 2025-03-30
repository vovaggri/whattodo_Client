//
//  CreateGoalAssembly.swift
//  WhatToDoPlanner


//
final class CreateGTaskAssembly  {
    static func assembly() -> CreateGTaskViewController {
        let viewController = CreateGTaskViewController()
        let interactor = CreateGTaskInteractor()
        let presenter = CreateGTaskPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}




