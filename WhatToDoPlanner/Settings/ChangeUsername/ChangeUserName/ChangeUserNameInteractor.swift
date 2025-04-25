import Foundation

protocol ChangeUsernameBusinessLogic {
  func fetchCurrentName(request: ChangeUsername.Fetch.Request)
  func updateName(request: ChangeUsername.Update.Request)
}

final class ChangeUsernameInteractor: ChangeUsernameBusinessLogic {
  // SVIP: interactor -> presenter
  var presenter: ChangeUsernamePresentationLogic?
    var worker: ChangeUsernameWorkerProtocol?

  // In a real app you'd inject a user service / worker here
    private var currentFirstName: String
    private var currentLastName: String
    
    init(presenter: ChangeUsernamePresentationLogic?, worker: ChangeUsernameWorkerProtocol?, currentFirstName: String, currentLastName: String) {
        self.presenter = presenter
        self.worker = worker
        self.currentFirstName = currentFirstName
        self.currentLastName = currentLastName
    }

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

        let workerRequest = ChangeUsername.UpdateModelName(firstName: currentFirstName, secondName: currentLastName)
        worker?.changeFullName(requestData: workerRequest) { [weak self] result in
            switch result {
            case.success:
                print("User updated")
                DispatchQueue.main.async {
                    self?.presenter?.navigateBack()
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
        }
        
//      presenter?.presentUpdateResult(response: resp)
    }
  }
}
