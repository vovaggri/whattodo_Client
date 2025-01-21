import UIKit

class SignUpInteractor: SignUpInteractorProtocol {
    var presenter: SignUpPresenterProtocol?

    func validateAndSignUp(firstName: String, lastName: String, email: String, password: String) {
        if email.contains("@") && password.count >= 6 {
            // Validation successful
            (presenter as? SignUpPresenter)?.router?.navigateToNextScreen()
        } else {
            presenter?.view?.showError(message: "Invalid email or password.")
        }
    }
}
