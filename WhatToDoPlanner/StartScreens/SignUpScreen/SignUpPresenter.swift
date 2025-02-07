import UIKit

protocol SignUpPresenterProtocol: AnyObject {
    func showError(message: String)
    func signUpSuccess()
}

final class SignUpPresenter: SignUpPresenterProtocol {
    weak var view: SignUpViewController?
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        view?.present(alert, animated: true)
    }
    
    func signUpSuccess() {
        print("Succes")
        navigateToNextScreen()
    }
    
    private func navigateToNextScreen() {
        let confirmVC = ConfirmModuleAssembly.assembly()
        
        // Ensure the viewController has a navigationController
        guard let navigationController = view?.navigationController else {
            print("Error: navigationController is nil. Ensure the viewController is embedded in a UINavigationController.")
            return
        }
        
        navigationController.pushViewController(confirmVC, animated: true)
    }
}
