//
//  Create.swift
//  WhatToDoPlanner

protocol CreateTaskInteractorProtocol {
    func uploadTask()
}

final class CreateTaskInteractor: CreateTaskInteractorProtocol {
    private var presenter: CreateTaskPresenterProtocol?
    private var worker: CreateTaskWorkerProtocol?
    
//    private var task: Task
    
    init(presenter: CreateTaskPresenterProtocol?, worker: CreateTaskWorkerProtocol?) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func uploadTask() {
        
    }
}

