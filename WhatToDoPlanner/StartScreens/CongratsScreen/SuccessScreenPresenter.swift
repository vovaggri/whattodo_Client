import UIKit

protocol SuccessScreenPresentationLogic {
    func presentSuccessMessage(response: SuccessScreen.SuccessMessage.Response)
}

class SuccessScreenPresenter: SuccessScreenPresentationLogic {
    weak var viewController: SuccessScreenDisplayLogic?
    
    func presentSuccessMessage(response: SuccessScreen.SuccessMessage.Response) {
        let viewModel = SuccessScreen.SuccessMessage.ViewModel(message: response.message)
        viewController?.displaySuccessMessage(viewModel)
    }
}
