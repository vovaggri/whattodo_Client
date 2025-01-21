import UIKit

protocol WelcomeRouterProtocol {
    func navigateToSignUpScreen()
}

final class WelcomeRouter: WelcomeRouterProtocol {
    weak var welcomeVC: UIViewController? // Use weak to prevent retain cycles
    
    func navigateToSignUpScreen() {
        print("Router works")
        
        // Debugging logs
        print("welcomeVC: \(String(describing: welcomeVC))") // Check if welcomeVC is properly initialized
        print("navigationController: \(String(describing: welcomeVC?.navigationController))") // Check if navigationController is available
        
        // Ensure welcomeVC is not nil and has a navigationController
        guard let navigationController = welcomeVC?.navigationController else {
            print("Error: navigationController is nil. Ensure WelcomeViewController is embedded in a UINavigationController.")
            return
        }
        
        // Create the welcome view controller using your assembly
        let welcomeVC = SignUpModuleBuilder.build()
        navigationController.pushViewController(welcomeVC, animated: true)
    }
}
