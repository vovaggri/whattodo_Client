// MainScreenPresenter.swift

import UIKit

protocol MainScreenPresentationLogic {
    func presentMainScreenData(response: MainScreen.Fetch.Response)
}

final class MainScreenPresenter: MainScreenPresentationLogic {
    
    weak var viewController: MainScreenViewController?
    
    func presentMainScreenData(response: MainScreen.Fetch.Response) {
        let viewModel = MainScreen.Fetch.ViewModel(
            greetingText: response.greeting,
            avatarImage: response.avatar
        )
        viewController?.displayMainScreenData(viewModel: viewModel)
    }
}
