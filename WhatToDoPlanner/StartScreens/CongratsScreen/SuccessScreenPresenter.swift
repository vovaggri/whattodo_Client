import UIKit

protocol SuccessScreenPresentationLogic {
    func presentSuccessMessage(response: SuccessScreen.SuccessMessage.Response)
    func navigateToMainScreen()
}

final class SuccessScreenPresenter: SuccessScreenPresentationLogic {
    weak var viewController: SuccessScreenViewController?
    
    func presentSuccessMessage(response: SuccessScreen.SuccessMessage.Response) {
        let viewModel = SuccessScreen.SuccessMessage.ViewModel(message: response.message)
        viewController?.displaySuccessMessage(viewModel)
    }
    
    func navigateToMainScreen() {
        viewController?.navigationController?.setViewControllers([MainAssembly.assembly()], animated: true)
    }
}
