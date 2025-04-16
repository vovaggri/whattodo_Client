//
//  BottomAssembly.swift
//  WhatToDoPlanner

import UIKit

final class BottomAssembly {
    static func assembly() -> BottomSheetViewController {
        let viewController = BottomSheetViewController()
        let presenter = BottomPresenter()
        let worker = BottomWorker()
        let interactor = BottomInteractor(presenter: presenter, worker: worker)
        
        viewController.interactor = interactor
        presenter.bottomVC = viewController
        
        return viewController
    }
    
    static func assembly(_ task: Task) {
        
    }
}
