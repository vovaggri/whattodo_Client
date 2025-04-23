final class GoalReviewInteractor {
    private let presenter: GoalReviewPresenter
    private let goal: Goal
    
    init(presenter: GoalReviewPresenter, goal: Goal) {
        self.presenter = presenter
        self.goal = goal
    }
    
    func loadGoal() {
        let request = GoalReviewModels.Request(goal: goal)
        presenter.presentGoal(request: request)
    }
}
