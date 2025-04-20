protocol ChangeGoalPresentationLogic {
    func presentGoal(response: ChangeGoalModels.Response, viewModel: ChangeGoalModels.ViewModel)
}

final class ChangeGoalPresenter: ChangeGoalPresentationLogic {
    weak var viewController: ChangeGoalViewController?
    
    func presentGoal(response: ChangeGoalModels.Response, viewModel: ChangeGoalModels.ViewModel) {
//        viewController?.display(viewModel: viewModel)
    }
}
