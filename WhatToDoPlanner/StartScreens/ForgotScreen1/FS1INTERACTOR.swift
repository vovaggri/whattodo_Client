import Foundation

protocol ForgotScreenBusinessLogic {
    func fetchForgotData(email: String?)
}

final class ForgotScreenInteractor: ForgotScreenBusinessLogic {
    var presenter: ForgotScreenPresentationLogic?
    var worker: ForgotScreenWorkerProtocol?
    
    func fetchForgotData(email: String?) {
        // In a real application, you might call a network service here.
//        let response = ForgotScreen.Fetch.Response(emailPlaceholder: "Enter your email address")
//        presenter?.presentForgotData(response: response)
        
        guard let email = email, !email.isEmpty else {
            presenter?.showErrorAlert("Email field is required")
            return
        }
        validateAndPinCode(email: email)
    }
    
    private func validateAndPinCode(email: String) {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let isEmailValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        
        guard isEmailValid else {
            presenter?.showErrorAlert("Email is required")
            return
        }
        
        let request = ForgotScreen.Fetch.Request(email: email)
        worker?.sendEmail(emailRequest: request) { [weak self] result in
            switch result {
            case.success:
                print("Self in closure: \(String(describing: self))")
                self?.presenter?.navigateToPin(email: email)
            case.failure(let error):
                self?.presenter?.showErrorAlert(error.localizedDescription)
            }
        }
    }
}
