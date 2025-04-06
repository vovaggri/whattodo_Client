
protocol ForgotScreenBusinessLogic {
    func fetchForgotData(request: ForgotScreen.Fetch.Request)
}

final class ForgotScreenInteractor: ForgotScreenBusinessLogic {
    var presenter: ForgotScreenPresentationLogic?
    
    func fetchForgotData(request: ForgotScreen.Fetch.Request) {
        // In a real application, you might call a network service here.
        let response = ForgotScreen.Fetch.Response(emailPlaceholder: "Enter your email address")
        presenter?.presentForgotData(response: response)
    }
}
