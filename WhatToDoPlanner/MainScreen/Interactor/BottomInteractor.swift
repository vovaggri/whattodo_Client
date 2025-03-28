//
//  BottomInteractor.swift
//  WhatToDoPlanner

import UIKit

protocol BottomBusinessLogic {
    func switcherPressed()
    func detentChanged(newDetent: UISheetPresentationController.Detent.Identifier?)
    func loadTasks()
}

final class BottomInteractor: BottomBusinessLogic {
    private var presenter: BottomPresentationLogic?
    private var worker: BottomWorkerProtocol?
    
    init(presenter: BottomPresentationLogic?, worker: BottomWorkerProtocol?) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func switcherPressed() {
        presenter?.switchMode()
    }
    
    func detentChanged(newDetent: UISheetPresentationController.Detent.Identifier?) {
        let isLarge = newDetent == .large
        presenter?.updateMode(isLarge: isLarge)
    }
    
    func loadTasks() {
        worker?.getTasks { [weak self] tasks in
            // Обновляем UI в главном потоке, если presenter работает с UI
            DispatchQueue.main.async {
                self?.presenter?.showTasks(with: tasks)
            }
        }
    }
}
