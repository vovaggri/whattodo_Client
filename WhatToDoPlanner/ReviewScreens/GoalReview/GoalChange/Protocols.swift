
protocol ChangeGoalBusinessLogic {
  func changeGoal(id: Int, title: String, description: String, color: Int)
}

protocol ChangePresentationLogic {
    func presentCreate(response: ChangeGoalModels.Create.Response)
    func navigateMainScreen()
    func showErrorAlert(_ message: String?)
}

protocol ChangeGoalWorkerProtocol {
    func updateGoal(id: Int, with requestData: CreateGoal.CreateGoalRequest, completion: @escaping (Result<Void, any Error>) -> Void)
}
