import Foundation

protocol ChangeUsernamePresentationLogic {
  func presentCurrentName(response: ChangeUsername.Fetch.Response)
  func presentUpdateResult(response: ChangeUsername.Update.Response)
    func showErrorAlert(_ message: String?)
    func navigateBack()
}

final class ChangeUsernamePresenter: ChangeUsernamePresentationLogic {
    weak var viewController: ChangeUsernameViewController?

  func presentCurrentName(response: ChangeUsername.Fetch.Response) {
    let vm = ChangeUsername.Fetch.ViewModel(
      firstName: response.firstName,
      lastName:  response.lastName
    )
    viewController?.displayCurrentName(viewModel: vm)
  }

  func presentUpdateResult(response: ChangeUsername.Update.Response) {
    let vm = ChangeUsername.Update.ViewModel(
      isSuccess:    response.success,
      errorMessage: response.errorMessage
    )
      viewController?.returnSaveButton()
    viewController?.displayUpdateResult(viewModel: vm)
  }
    
    func showErrorAlert(_ message: String?) {
        viewController?.returnSaveButton()
        viewController?.showError(message: message ?? "Error")
    }
    
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
