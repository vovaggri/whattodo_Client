//
//  BottomAssembly.swift
//  WhatToDoPlanner

import UIKit

final class BottomAssembly {
    static func assembly() -> BottomSheetViewController {
        let viewController = BottomSheetViewController()
        let presenter = BottomPresenter()
        let interactor = BottomInteractor(presenter: presenter)
        
        viewController.interactor = interactor
        presenter.bottomVC = viewController
        
        return viewController
    }
}
