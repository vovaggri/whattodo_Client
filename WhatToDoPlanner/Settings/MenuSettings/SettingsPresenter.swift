protocol SettingsPresentationLogic {
    func showErrorAlert(_ message: String?)
    func showUser(_ user: MainModels.Fetch.UserResponse)
    func navigateToWelcomeScreen()
}

final class SettingsPresenter: SettingsPresentationLogic {
    weak var viewController: SettingsVC?
    
    func showErrorAlert(_ message: String?) {
        viewController?.showError(message: message ?? "Error")
    }
    
    func showUser(_ user: MainModels.Fetch.UserResponse) {
        viewController?.displayUser(user)
    }
    
    func navigateToWelcomeScreen() {
        let welcomeVC = WelcomeModuleAssembly.assembly()
        viewController?.navigationController?.setViewControllers([welcomeVC], animated: true)
    }
}
