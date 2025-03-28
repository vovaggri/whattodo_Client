//
//  Create.swift
//  WhatToDoPlanner

protocol CreateTaskInteractorProtocol {
    
}

final class CreateTaskInteractor: CreateTaskInteractorProtocol {
    private var presenter: CreateTaskPresenterProtocol?
    
    init(presenter: CreateTaskPresenterProtocol?) {
        self.presenter = presenter
    }
}

