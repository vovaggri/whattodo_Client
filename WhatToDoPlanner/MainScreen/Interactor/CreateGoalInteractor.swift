//
//  Create.swift
//  WhatToDoPlanner

protocol CreateGoalInteractorProtocol {
    
}

final class CreateGoalInteractor: CreateGoalInteractorProtocol {
    private var presenter: CreateGoalPresenterProtocol?
    
    init(presenter: CreateGoalPresenterProtocol?) {
        self.presenter = presenter
    }
}

