// MainScreenInteractor.swift

import UIKit

protocol MainScreenBusinessLogic {
    func fetchMainScreenData(request: MainModels.Fetch.Request)
    func navigateToCreateGoal()
}

final class MainScreenInteractor: MainScreenBusinessLogic {
    
    private var presenter: MainScreenPresentationLogic?
    
    init(presenter: MainScreenPresentationLogic) {
        self.presenter = presenter
    }
    
    func fetchMainScreenData(request: MainModels.Fetch.Request) {
        // Simulate fetching only header data
        let avatar = UIImage(named: "avatar")
        
        let greeting = "Hi, Jovana!"
        let categories: [MainModels.Fetch.CategoryViewModel] = []

        
        // Create the response with no categories/tasks
        let response = MainModels.Fetch.Response(
            greeting: greeting,
            avatar: avatar,
            categories: categories
        )
        
        presenter?.presentMainScreenData(response: response)
    }
    
    func navigateToCreateGoal() {
        presenter?.navigateToCreateGoal()
    }
}
