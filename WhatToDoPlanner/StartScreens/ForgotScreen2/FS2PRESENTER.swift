protocol ChangePasswordPresentationLogic {
    func presentSuccess()
    func presentError(message: String)
}

final class ChangePasswordPresenter: ChangePasswordPresentationLogic {
    weak var viewController: ChangePasswordViewController?

    func presentSuccess() {
        viewController?.navigateToApp()
    }

    func presentError(message: String) {
        viewController?.showError(message: message)
    }
}
