protocol GoalReviewPresentationLogic {
    func presentGoal(request: GoalReviewModels.Request)
    func showErrorAlert(_ message: String?)
    func navigateToProblem()
    func navigateToAI(with goalId: Int)
    func navigateToMainScreen()
}

final class GoalReviewPresenter: GoalReviewPresentationLogic {
    weak var viewController: GoalReviewViewController?
    
    func presentGoal(request: GoalReviewModels.Request) {
        let goal = request.goal
        let viewModel = GoalReviewModels.ViewModel(
            title: goal.title,
            color: goal.getColour()
        )
        viewController?.displayGoal(viewModel: viewModel)
    }
    
    func showErrorAlert(_ message: String?) {
        viewController?.showError(message: message ?? "Error")
    }
    
    func navigateToProblem() {
        viewController?.showProblemAI()
    }
    
    func navigateToAI(with goalId: Int) {
        let aiVC = AIAssembly.assembly(with: goalId)
        viewController?.navigationController?.pushViewController(aiVC, animated: true)
    }
    
    func navigateToMainScreen() {
        let mainVC = MainAssembly.assembly()
        viewController?.navigationController?.setViewControllers([mainVC], animated: true)
    }
}
