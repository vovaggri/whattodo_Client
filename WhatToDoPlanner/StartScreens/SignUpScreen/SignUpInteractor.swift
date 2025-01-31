import UIKit

protocol SignUpInteractorProtocol: AnyObject {
    func validateAndSignUp(firstName: String, lastName: String, email: String, password: String)
}

final class SignUpInteractor: SignUpInteractorProtocol {
    var presenter: SignUpPresenterProtocol?
    private let signUpService: SignUpServiceProtocol
    
    init(signUpService: SignUpServiceProtocol = SignUpService()) {
        self.signUpService = signUpService
    }

    func validateAndSignUp(firstName: String, lastName: String, email: String, password: String) {
//        if email.contains("@") && password.count >= 6 {
//            // Validation successful
//            (presenter as? SignUpPresenter)?.router?.navigateToNextScreen()
//        } else {
//            presenter?.view?.showError(message: "Invalid email or password.")
//        }
        
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let isEmailValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        
        guard isEmailValid, password.count >= 6 else {
            presenter?.view?.showError(message: "Invalid email or password.")
            return
        }
        
        signUpService.signUp(firstName: firstName, lastName: lastName, email: email, password: password) { [weak self] result in
            switch result {
            case.success:
                self?.presenter?.signUpSuccess()
            case.failure(let error):
                self?.presenter?.view?.showError(message: error.localizedDescription)
            }
        }
    }
}
