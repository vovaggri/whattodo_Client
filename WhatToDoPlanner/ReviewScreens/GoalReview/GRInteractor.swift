protocol GoalReviewBusinessLogic {
    func loadGoal()
    func checkGoal(with goal: Goal)
}

final class GoalReviewInteractor : GoalReviewBusinessLogic {
    private let presenter: GoalReviewPresentationLogic?
    private let goal: Goal
    
    init(presenter: GoalReviewPresentationLogic, goal: Goal) {
        self.presenter = presenter
        self.goal = goal
    }
    
    func loadGoal() {
        let request = GoalReviewModels.Request(goal: goal)
        presenter?.presentGoal(request: request)
    }
    
    func checkGoal(with goal: Goal) {
        if goal.description == "" || goal.description == nil {
            presenter?.navigateToProblem()
        } else {
            presenter?.navigateToAI(with: goal.id)
        }
    }
}
