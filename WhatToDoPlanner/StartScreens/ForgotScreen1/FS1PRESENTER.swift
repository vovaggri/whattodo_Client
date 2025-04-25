protocol ForgotScreenPresentationLogic {
    func presentForgotData(response: ForgotScreen.Fetch.Response)
    func showErrorAlert(_ message: String?)
    func navigateToPin(email: String)
}
final class ForgotScreenPresenter: ForgotScreenPresentationLogic {
    // Instead of using a separate display protocol, we refer directly to the view controller.
    weak var viewController: ForgotScreenViewController?
    
    func presentForgotData(response: ForgotScreen.Fetch.Response) {
        let viewModel = ForgotScreen.Fetch.ViewModel(emailPlaceholder: response.emailPlaceholder)
        viewController?.updateEmailPlaceholder(with: viewModel.emailPlaceholder)
    }
    
    func showErrorAlert(_ message: String?) {
        viewController?.returnContinueButton()
        viewController?.showError(message: message ?? "Error")
    }
    
    func navigateToPin(email: String) {
        let pinCodeVC = PinCodeAssembly.assemble(email: email)
        viewController?.navigationController?.pushViewController(pinCodeVC, animated: true)
    }
}
