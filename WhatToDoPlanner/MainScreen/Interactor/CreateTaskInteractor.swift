//
//  Create.swift
//  WhatToDoPlanner

import Foundation

protocol CreateTaskInteractorProtocol {
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
    
    func uploadTask(title: String, date: Date, color: Int, description: String?, startTime: Date?, endTime: Date?, goalId: Int?) {
        let task = Task(
            id: 1,
            title: title,
            description: description,
            colour: color,
            endDate: date,
            done: false,
            startTime: startTime,
            endTime: endTime,
            goalId: goalId
        )
        
        worker?.createTask(with: task) { [weak self] result in
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
}

