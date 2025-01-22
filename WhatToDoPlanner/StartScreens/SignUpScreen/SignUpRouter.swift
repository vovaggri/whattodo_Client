import UIKit

protocol SignUpRouterProtocol: AnyObject {
    func navigateToNextScreen()
}

final class SignUpRouter: SignUpRouterProtocol {
    weak var viewController: UIViewController?

    func navigateToNextScreen() {
        let nextVC = UIViewController() // Replace with actual screen
        nextVC.view.backgroundColor = .white
        
        // Ensure the viewController has a navigationController
        guard let navigationController = viewController?.navigationController else {
            print("Error: navigationController is nil. Ensure the viewController is embedded in a UINavigationController.")
            return
        }
        
        // Proceed with navigation
        navigationController.pushViewController(nextVC, animated: true)

        // Create and push the SignUp view controller
        let signUpVC = SignUpModuleBuilder.build()
        navigationController.pushViewController(signUpVC, animated: true)
    }
}



