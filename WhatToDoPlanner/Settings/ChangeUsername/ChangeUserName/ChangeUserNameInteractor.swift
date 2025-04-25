import Foundation

protocol ChangeUsernameBusinessLogic {
  func fetchCurrentName(request: ChangeUsername.Fetch.Request)
  func updateName(request: ChangeUsername.Update.Request)
}

final class ChangeUsernameInteractor: ChangeUsernameBusinessLogic {
  // SVIP: interactor -> presenter
  var presenter: ChangeUsernamePresentationLogic?

  // In a real app you'd inject a user service / worker here
  private var currentFirstName = "Jovana"
  private var currentLastName  = "Ristevska"

  // Initial load
  func fetchCurrentName(request: ChangeUsername.Fetch.Request) {
    let resp = ChangeUsername.Fetch.Response(
      firstName: currentFirstName,
      lastName:  currentLastName
    )
    presenter?.presentCurrentName(response: resp)
  }

  // Handle “Save”
  func updateName(request: ChangeUsername.Update.Request) {
    // pretend success if non-empty
    if request.firstName.isEmpty || request.lastName.isEmpty {
      let resp = ChangeUsername.Update.Response(
        success:      false,
        errorMessage: "Both fields are required"
      )
      presenter?.presentUpdateResult(response: resp)
    } else {
      // save to model (in real app, call service)
      currentFirstName = request.firstName
      currentLastName  = request.lastName

      let resp = ChangeUsername.Update.Response(
        success:      true,
        errorMessage: nil
      )
      presenter?.presentUpdateResult(response: resp)
    }
  }
}
