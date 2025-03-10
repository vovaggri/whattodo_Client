// MainScreenInteractor.swift

import UIKit

protocol MainScreenBusinessLogic {
    func fetchMainScreenData(request: MainScreen.Fetch.Request)
}

final class MainScreenInteractor: MainScreenBusinessLogic {
    
    private var presenter: MainScreenPresentationLogic?
    
    init(presenter: MainScreenPresentationLogic) {
        self.presenter = presenter
    }
    
    func fetchMainScreenData(request: MainScreen.Fetch.Request) {
        // Simulate fetching only header data
        let avatar = UIImage(named: "avatar")
        let greeting = "Hi, Jovana!"
        
        // Create the response with no categories/tasks
        let response = MainScreen.Fetch.Response(
            greeting: greeting,
            avatar: avatar
        )
        
        presenter?.presentMainScreenData(response: response)
    }
}
