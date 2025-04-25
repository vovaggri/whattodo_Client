import Foundation

protocol ChangeUsernamePresentationLogic {
  func presentCurrentName(response: ChangeUsername.Fetch.Response)
  func presentUpdateResult(response: ChangeUsername.Update.Response)
}

final class ChangeUsernamePresenter: ChangeUsernamePresentationLogic {
  weak var viewController: ChangeUsernameDisplayLogic?

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
    viewController?.displayUpdateResult(viewModel: vm)
  }
}
