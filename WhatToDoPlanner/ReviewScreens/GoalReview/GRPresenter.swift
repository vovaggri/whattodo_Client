final class GoalReviewPresenter {
    weak var viewController: GoalReviewViewController?
    
    func presentGoal(request: GoalReviewModels.Request) {
        let goal = request.goal
        let viewModel = GoalReviewModels.ViewModel(
            title: goal.title,
            color: goal.getColour()
        )
        viewController?.displayGoal(viewModel: viewModel)
    }
}
