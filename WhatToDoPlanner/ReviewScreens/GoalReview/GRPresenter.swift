protocol GoalReviewPresentationLogic {
    func presentGoal(request: GoalReviewModels.Request)
    func showErrorAlert(_ message: String?)
    func navigateToProblem()
    func navigateToAI(with goalId: Int)
    func navigateToMainScreen()
    func showTasks(with tasks: [Task])
    func navigateToTR(_ selectedTask: Task)
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
    
    func showTasks(with tasks: [Task]) {
        viewController?.showTasks(with: tasks)
    }
    
    func navigateToTR(_ selectedTask: Task) {
        let reviewVC = ReviewScreenAssembly.assembly(selectedTask)
        viewController?.navigationController?.pushViewController(reviewVC, animated: true)
    }
}
