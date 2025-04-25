import Foundation

protocol ChangeTaskPresentationLogic {
    func presentTaskUpload(response: ChangeTaskModels.Response)
    func showGoals(with goals: [Goal])
    func showErrorAlert(_ message: String?)
    func navigateMainScreen()
}

final class ChangeTaskPresenter: ChangeTaskPresentationLogic {
    weak var viewController: ChangeTaskViewController?

    func presentTaskUpload(response: ChangeTaskModels.Response) {
        let message = response.success ? "Task successfully updated!" : "Failed to update task."
        let viewModel = ChangeTaskModels.ViewModel(message: message)
        viewController?.displayTaskUpload(viewModel: viewModel)
    }
    
    func showGoals(with goals: [Goal]) {
        viewController?.showGoals(with: goals)
    }
    
    func showErrorAlert(_ message: String?) {
        viewController?.showError(message: message ?? "Error")
    }
    
    func navigateMainScreen() {
        let mainVC = MainAssembly.assembly()
        viewController?.navigationController?.setViewControllers([mainVC], animated: true)
    }
}
