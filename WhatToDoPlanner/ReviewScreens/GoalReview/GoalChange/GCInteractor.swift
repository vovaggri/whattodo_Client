final class CreateNewGoalInteractor: CreateNewGoalBusinessLogic {
  var presenter: CreateNewGoalPresentationLogic?

  func createGoal(request: CreateNewGoalModels.Create.Request) {
    // → perform your save/network here…
    // On completion:
      let response = CreateNewGoalModels.Create.Response(success: true, errorMessage: nil)
    presenter?.presentCreate(response: response)
  }
}
