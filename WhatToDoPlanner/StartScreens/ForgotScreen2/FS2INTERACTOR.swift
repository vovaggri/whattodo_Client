protocol ChangePasswordBusinessLogic {
    func submitChange(request: ChangePasswordModels.Request)
}

final class ChangePasswordInteractor: ChangePasswordBusinessLogic {
    var presenter: ChangePasswordPresentationLogic?
    var worker: ChangePasswordWorkerProtocol?

    func submitChange(request: ChangePasswordModels.Request) {
//        guard !request.code.isEmpty, !request.newPassword.isEmpty else {
//            presenter?.presentError(message: "Both fields are required.")
//            return
//        }

        if request.newPassword == "" {
            presenter?.presentError(message: "Empty password field.")
            return
        }
        
        worker?.resetPassword(with: request) { [weak self] result in
            switch result {
            case.success:
                print("Self in closure: \(String(describing: self))")
                self?.presenter?.presentSuccess()
            case.failure(let error):
                self?.presenter?.presentError(message: error.localizedDescription)
            }
        }
    }
}
