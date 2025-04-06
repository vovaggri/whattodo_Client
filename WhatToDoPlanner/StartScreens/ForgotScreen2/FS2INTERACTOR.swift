protocol ChangePasswordBusinessLogic {
    func submitChange(request: ChangePasswordModels.Request)
}

final class ChangePasswordInteractor: ChangePasswordBusinessLogic {
    var presenter: ChangePasswordPresentationLogic?

    func submitChange(request: ChangePasswordModels.Request) {
        guard !request.code.isEmpty, !request.newPassword.isEmpty else {
            presenter?.presentError(message: "Both fields are required.")
            return
        }

        // Imagine a real API call here...
        presenter?.presentSuccess()
    }
}
