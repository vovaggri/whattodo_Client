//
//  BottomInteractor.swift
//  WhatToDoPlanner

import UIKit

protocol BottomBusinessLogic {
    func switcherPressed()
    func detentChanged(newDetent: UISheetPresentationController.Detent.Identifier?)
    func loadTasks()
    func addTaskButton()
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
        worker?.getTasks { [weak self] result in
            switch result {
            case.success(let tasks):
                let today = Date()
                var calendar = Calendar.current
                calendar.timeZone = TimeZone.current  // Убеждаемся, что используем локальный часовой пояс
                        
                let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
                let todaysTasksFilter = tasks.filter { task in
                    let taskComponents = calendar.dateComponents([.year, .month, .day], from: task.endDate)
                    return taskComponents.year == todayComponents.year &&
                            taskComponents.month == todayComponents.month &&
                            taskComponents.day == todayComponents.day
                }
                
                // Обновляем UI в главном потоке, если presenter работает с UI
                DispatchQueue.main.async {
                    self?.presenter?.showTasks(with: todaysTasksFilter)
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showTasks(with: [])
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
    
    func addTaskButton() {
        presenter?.navigateToCreateTaskVC()
    }
}
