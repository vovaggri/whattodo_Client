protocol ForgotScreenPresentationLogic {
    func presentForgotData(response: ForgotScreen.Fetch.Response)
}
final class ForgotScreenPresenter: ForgotScreenPresentationLogic {
    // Instead of using a separate display protocol, we refer directly to the view controller.
    weak var viewController: ForgotScreenViewController?
    
    func presentForgotData(response: ForgotScreen.Fetch.Response) {
        let viewModel = ForgotScreen.Fetch.ViewModel(emailPlaceholder: response.emailPlaceholder)
        viewController?.updateEmailPlaceholder(with: viewModel.emailPlaceholder)
    }
}
