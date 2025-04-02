// MainScreenPresenter.swift

import UIKit

protocol MainScreenPresentationLogic {
    func presentMainScreenData(response: MainModels.Fetch.Response)
    func navigateToCreateGoal()
    func showErrorAlert(_ message: String?)
}

final class MainScreenPresenter: MainScreenPresentationLogic {
    
    weak var viewController: MainScreenViewController?
    
    func presentMainScreenData(response: MainModels.Fetch.Response) {
        let viewModel = MainModels.Fetch.ViewModel(
            greetingText: response.greeting,
            avatarImage: response.avatar,
            categories: [] // Pass an empty array for now
        )
        viewController?.displayMainScreenData(viewModel: viewModel)
    }

//    func navigateToCreateGoal() {
//        let createGoalVC = CreateGoalAssembly.assembly()
//        viewController?.navigationController?.pushViewController(createGoalVC, animated: true)
//    }
    func navigateToCreateGoal() {
        // pass `viewController` (which is MainScreenViewController) as the delegate
        guard let mainVC = viewController else { return }
//        let createTaskVC = CreateTaskAssembly.assembly(delegate: mainVC as? CreateTaskViewControllerDelegate)
//        mainVC.navigationController?.pushViewController(createTaskVC, animated: true)
    }

    func showErrorAlert(_ message: String?) {
        viewController?.showError(message: message ?? "Error")
    }
}
