final class ChangeGoalPresenter: ChangePresentationLogic {
    weak var viewController: ChangeGoalViewController?

    func presentCreate(response: ChangeGoalModels.Create.Response) {
        let vm = ChangeGoalModels.Create.ViewModel(
            alertTitle: response.success ? "Success" : "Error",
            alertMessage: response.success
            ? "Your goal was changed"
            : "Failed to change goal."
        )
        viewController?.displayCreate(viewModel: vm)
    }
    
    func navigateMainScreen() {
        let mainVC = MainAssembly.assembly()
        viewController?.navigationController?.setViewControllers([mainVC], animated: true)
    }
    
    func showErrorAlert(_ message: String?) {
        viewController?.showError(message: message ?? "Error")
    }
}
