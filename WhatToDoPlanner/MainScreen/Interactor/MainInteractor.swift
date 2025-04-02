// MainScreenInteractor.swift

import UIKit

protocol MainScreenBusinessLogic {
    func fetchMainScreenData(request: MainModels.Fetch.Request)
    func navigateToCreateGoal()
}

final class MainScreenInteractor: MainScreenBusinessLogic {
    
    private var presenter: MainScreenPresentationLogic?
    private var worker: MainWorkerProtocol?
    
    init(presenter: MainScreenPresentationLogic, worker: MainWorkerProtocol?) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func fetchMainScreenData(request: MainModels.Fetch.Request) {
        // Simulate fetching only header data
        let avatar = UIImage(named: "avatar")
        
        worker?.getUser { [weak self] result in
            switch result {
            case.success(let user):
                print("Self in closure: \(String(describing: self))")
                print("Done")
                DispatchQueue.main.async {
                    let userFirstName = user.firstName
                    print("User first name: \(userFirstName)")
                    
                    let greeting = "Hi, \(userFirstName)!"
                    let categories: [MainModels.Fetch.CategoryViewModel] = []
                    
                    // Create the response with no categories/tasks
                    let response = MainModels.Fetch.Response(
                        greeting: greeting,
                        avatar: avatar,
                        categories: categories
                    )
                    
                    self?.presenter?.presentMainScreenData(response: response)
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
    
    func navigateToCreateGoal() {
        presenter?.navigateToCreateGoal()
    }
}
