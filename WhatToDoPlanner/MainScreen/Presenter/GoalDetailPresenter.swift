protocol GoalDetailPresentationLogic {
    func presentGoalInfo(response: GoalDetail.Info.Response)
}

final class GoalDetailPresenter: GoalDetailPresentationLogic {
    weak var viewController: GoalDetailDisplayLogic?

    func presentGoalInfo(response: GoalDetail.Info.Response) {
        let viewModel = GoalDetail.Info.ViewModel(title: response.title)
        viewController?.displayGoalInfo(viewModel: viewModel)
    }
    
}
