protocol GoalDetailPresentationLogic {
    func presentGoalInfo(response: Goal)
    func showErrorAlert(_ message: String?)
    func showTasks(with tasks: [Task])
}

final class GoalDetailPresenter: GoalDetailPresentationLogic {
    weak var viewController: GoalDetailViewController?

    func presentGoalInfo(response: Goal) {
        let viewModel = GoalDetail.Info.ViewModel(title: response.title)
        viewController?.displayGoalInfo(viewModel: viewModel, goalResponse: response)
    }
    
    func showErrorAlert(_ message: String?) {
        viewController?.showError(message: message ?? "Error")
    }
    
    func showTasks(with tasks: [Task]) {
        viewController?.showTasks(with: tasks)
    }
}
