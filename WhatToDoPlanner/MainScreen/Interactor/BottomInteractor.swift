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
        worker?.getTasks { [weak self] tasks in
            // Создаем изменяемую копию каждой задачи с исправленными датами
            let fixedTasks = tasks.map { task -> Task in
                var mutableTask = task
                mutableTask.startTime = self?.fixYearIfNeeded(task.startTime)
                mutableTask.endTime = self?.fixYearIfNeeded(task.endTime)
                return mutableTask
            }
            
            let today = Date()
            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current  // Убеждаемся, что используем локальный часовой пояс
                    
            let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
            let todaysTasksFilter = fixedTasks.filter { task in
                let taskComponents = calendar.dateComponents([.year, .month, .day], from: task.endDate)
                return taskComponents.year == todayComponents.year &&
                        taskComponents.month == todayComponents.month &&
                        taskComponents.day == todayComponents.day
            }
            
            // Обновляем UI в главном потоке, если presenter работает с UI
            DispatchQueue.main.async {
                self?.presenter?.showTasks(with: todaysTasksFilter)
            }
        }
    }
    
    func addTaskButton() {
        presenter?.navigateToCreateTaskVC()
    }
    
    // Функция для корректировки даты: если год равен 0, заменяем его на 1970
    private func fixYearIfNeeded(_ date: Date?) -> Date? {
        guard let date = date else { return nil }
        var calendar = Calendar(identifier: .gregorian)
        // Если нужно работать с UTC, можно установить:
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        if let year = components.year, year == 0 {
            components.year = 1970
            return calendar.date(from: components)
        }
        return date
    }
}
