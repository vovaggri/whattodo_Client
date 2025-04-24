final class CreateNewGoalPresenter: CreateNewGoalPresentationLogic {
  weak var viewController: CreateNewGoalDisplayLogic?

  func presentCreate(response: CreateNewGoalModels.Create.Response) {
    let vm = CreateNewGoalModels.Create.ViewModel(
      alertTitle: response.success ? "Success" : "Error",
      alertMessage: response.success
        ? "Your goal was changed"
        : "Failed to change goal."
    )
    viewController?.displayCreate(viewModel: vm)
  }
}
