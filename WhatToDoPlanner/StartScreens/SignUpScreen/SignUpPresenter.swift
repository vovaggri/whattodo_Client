protocol SignUpPresenterProtocol: AnyObject {
    var view: SignUpViewProtocol? { get set }
    func didTapSignUp(firstName: String?, lastName: String?, email: String?, password: String?)
}

final class SignUpPresenter: SignUpPresenterProtocol {
    weak var view: SignUpViewProtocol?
    var interactor: SignUpInteractorProtocol?
    var router: SignUpRouterProtocol?

    func didTapSignUp(firstName: String?, lastName: String?, email: String?, password: String?) {
        guard let firstName = firstName, !firstName.isEmpty,
              let lastName = lastName, !lastName.isEmpty,
              let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            view?.showError(message: "All fields are required.")
            return
        }
        interactor?.validateAndSignUp(firstName: firstName, lastName: lastName, email: email, password: password)
    }
}
