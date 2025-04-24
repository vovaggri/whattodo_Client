
protocol CreateNewGoalBusinessLogic {
  func createGoal(request: CreateNewGoalModels.Create.Request)
}

protocol CreateNewGoalPresentationLogic {
  func presentCreate(response: CreateNewGoalModels.Create.Response)
}

protocol CreateNewGoalDisplayLogic: AnyObject {
  func displayCreate(viewModel: CreateNewGoalModels.Create.ViewModel)
}
