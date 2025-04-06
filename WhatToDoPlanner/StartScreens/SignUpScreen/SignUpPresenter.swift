import UIKit

protocol SignUpPresenterProtocol: AnyObject {
    func showError(message: String)
    func signUpSuccess(email: String)
}

final class SignUpPresenter: SignUpPresenterProtocol {
    weak var view: SignUpViewController?
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        view?.present(alert, animated: true)
    }
    
    func signUpSuccess(email: String) {
        print("Succes")
        navigateToNextScreen(email: email)
    }
    
    private func navigateToNextScreen(email: String) {
        let confirmVC = ConfirmModuleAssembly.assembly(email: email)
        
        // Ensure the viewController has a navigationController
        guard let navigationController = view?.navigationController else {
            print("Error: navigationController is nil. Ensure the viewController is embedded in a UINavigationController.")
            return
        }
        
        navigationController.pushViewController(confirmVC, animated: true)
    }
}
