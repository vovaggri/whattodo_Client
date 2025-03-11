// MainScreenPresenter.swift

import UIKit

protocol MainScreenPresentationLogic {
    func presentMainScreenData(response: MainScreen.Fetch.Response)
    func navigateToCreateGoal()
}

final class MainScreenPresenter: MainScreenPresentationLogic {
    
    weak var viewController: MainScreenViewController?
    
    func presentMainScreenData(response: MainScreen.Fetch.Response) {
        let viewModel = MainScreen.Fetch.ViewModel(
            greetingText: response.greeting,
            avatarImage: response.avatar,
            categories: [] // Pass an empty array for now
        )
        viewController?.displayMainScreenData(viewModel: viewModel)
    }

    func navigateToCreateGoal() {
        let createGoalVC = CreateGoalAssembly.assembly()
        viewController?.navigationController?.pushViewController(createGoalVC, animated: true)
    }
}
