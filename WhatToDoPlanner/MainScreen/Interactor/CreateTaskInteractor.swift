//
//  Create.swift
//  WhatToDoPlanner

protocol CreateTaskInteractorProtocol {
    
}

final class CreateTaskInteractor: CreateTaskInteractorProtocol {
    private var presenter: CreateGoalPresenterProtocol?
    
    init(presenter: CreateGoalPresenterProtocol?) {
        self.presenter = presenter
    }
}

