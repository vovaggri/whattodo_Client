//
//  Create.swift
//  WhatToDoPlanner

import Foundation

protocol CreateTaskInteractorProtocol {
    func loadGoals()
    func uploadTask(title: String, date: Date, color: Int, description: String?, startTime: Date?, endTime: Date?, goalId: Int?)
}

final class CreateTaskInteractor: CreateTaskInteractorProtocol {
    private var presenter: CreateTaskPresenterProtocol?
    private var worker: CreateTaskWorkerProtocol?
    
//    private var task: Task
    
    init(presenter: CreateTaskPresenterProtocol?, worker: CreateTaskWorkerProtocol?) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func loadGoals() {
        worker?.getGoals { [weak self] result in
            switch result {
            case.success(let goals):
                DispatchQueue.main.async {
                    self?.presenter?.showGoals(with: goals)
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showGoals(with: [])
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
    
    func uploadTask(title: String, date: Date, color: Int, description: String?, startTime: Date?, endTime: Date?, goalId: Int?) {
        let fixedStartTime = fixedDate(from: startTime)
        let fixedEndTime = fixedDate(from: endTime)
        
        let task = CreateTaskModels.CreateTaskRequest(
            title: title,
            description: description,
            colour: color,
            endDate: date,
            done: false,
            startTime: fixedStartTime,
            endTime: fixedEndTime
        )
        
        worker?.createTask(with: task, goalId: goalId ?? 0) { [weak self] result in
            switch result {
            case.success:
                print("Self in closure: \(String(describing: self))")
                print("Done")
                DispatchQueue.main.async {
                    self?.presenter?.navigateMainScreen()
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
        }
        
        print("done")
    }
    
    private func fixedDate(from date: Date?) -> Date? {
        guard let date = date else { return nil }
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        if let year = components.year, year == 0 {
            components.year = 1970
            return calendar.date(from: components)
        }
        return date
    }
}

