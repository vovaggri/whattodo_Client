import Foundation

protocol ChangeTaskPresentationLogic {
    func presentTaskUpload(response: ChangeTaskModels.Response)
}

final class ChangeTaskPresenter: ChangeTaskPresentationLogic {
    weak var viewController: ChangeTaskDisplayLogic?

    func presentTaskUpload(response: ChangeTaskModels.Response) {
        let message = response.success ? "Task successfully updated!" : "Failed to update task."
        let viewModel = ChangeTaskModels.ViewModel(message: message)
        viewController?.displayTaskUpload(viewModel: viewModel)
    }
}
