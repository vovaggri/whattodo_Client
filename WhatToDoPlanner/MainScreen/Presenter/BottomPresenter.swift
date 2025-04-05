//
//  BottomPresenter.swift
//  WhatToDoPlanner

import UIKit

protocol BottomPresentationLogic {
    func switchMode()
    func updateMode(isLarge: Bool)
    func showTasks(with tasks: [Task])
    func navigateToCreateTaskVC()
    func showErrorAlert(_ message: String?)
}

final class BottomPresenter: BottomPresentationLogic {
    weak var bottomVC: BottomSheetViewController?
    private var isLargeMode = false
    
    func switchMode() {
        isLargeMode.toggle()
        let buttonTitle: String = isLargeMode ? BottomSheetViewController.Constants.switcherLargreText : BottomSheetViewController.Constants.switcherSmallText
        let detent: UISheetPresentationController.Detent.Identifier? = isLargeMode ? .large : .init(MainScreenViewController.Constants.smallIdentifier)
        
        // If bottomVC doesn't have custom identifier.
        let detentStandart: UISheetPresentationController.Detent.Identifier = isLargeMode ? .large : .medium
        
        bottomVC?.updateSwitcherButton(title: buttonTitle)
        bottomVC?.delegate?.changeDetent(to: detent ?? detentStandart)
    }
    
    func updateMode(isLarge: Bool) {
        isLargeMode = isLarge
        let buttonTitle = isLarge ? BottomSheetViewController.Constants.switcherLargreText : BottomSheetViewController.Constants.switcherSmallText
        bottomVC?.updateSwitcherButton(title: buttonTitle)
    }
    
    func showTasks(with tasks: [Task]) {
        bottomVC?.showTasks(with: tasks)
    }
    
    func navigateToCreateTaskVC() {
        print("presenter works")
        guard let bottomVC = bottomVC else { return }
        let createTaskVC = CreateTaskAssembly.assembly(delegate: bottomVC as? CreateTaskViewControllerDelegate)
        bottomVC.navigationController?.pushViewController(createTaskVC, animated: true)
    }
    
    func showErrorAlert(_ message: String?) {
        bottomVC?.showError(message: message ?? "Error")
    }
}
