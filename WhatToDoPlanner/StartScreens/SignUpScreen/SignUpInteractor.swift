import UIKit

protocol SignUpInteractorProtocol: AnyObject {
    func didTapSignUp(firstName: String?, lastName: String?, email: String?, password: String?)
    func validateAndSignUp(user: SignUpModels.User)
}

final class SignUpInteractor: SignUpInteractorProtocol {
    var presenter: SignUpPresenterProtocol?
    private let signUpService: SignUpServiceProtocol
    
    init(signUpService: SignUpServiceProtocol = SignUpService(), presenter: SignUpPresenterProtocol = SignUpPresenter()) {
        self.signUpService = signUpService
        self.presenter = presenter
    }
    
    func didTapSignUp(firstName: String?, lastName: String?, email: String?, password: String?) {
        guard let firstName = firstName, !firstName.isEmpty,
              let lastName = lastName, !lastName.isEmpty,
              let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            presenter?.showError(message: "All fields are required.")
            return
        }
        var user: SignUpModels.User = SignUpModels.User(firstName: firstName, lastName: lastName, email: email, password: password)
        validateAndSignUp(user: user)
    }

    func validateAndSignUp(user: SignUpModels.User) {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let isEmailValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: user.email)
        
        guard isEmailValid, user.password.count >= 6 else {
            presenter?.showError(message: "Invalid email or password.")
            return
        }
        
        signUpService.signUp(user: user) { [weak self] result in
            switch result {
            case.success:
                print("Self in closure: \(String(describing: self))")
                self?.presenter?.signUpSuccess()
                print("Done")
            case.failure(let error):
                self?.presenter?.showError(message: error.localizedDescription)
            }
        }
    }
}
