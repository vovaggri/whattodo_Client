//
//  BottomPresenter.swift
//  WhatToDoPlanner

import UIKit

protocol BottomPresentationLogic {
    func switchMode()
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
}
