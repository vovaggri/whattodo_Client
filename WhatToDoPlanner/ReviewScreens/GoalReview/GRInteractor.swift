import Foundation

protocol GoalReviewBusinessLogic {
    func loadGoal()
    func checkGoal(with goal: Goal)
    func deleteGoal(with goal: Goal)
}

final class GoalReviewInteractor : GoalReviewBusinessLogic {
    private var presenter: GoalReviewPresentationLogic?
    private var worker: GoalReviewWorkerProtocol?
    private let goal: Goal
    
    init(presenter: GoalReviewPresentationLogic, worker: GoalReviewWorkerProtocol, goal: Goal) {
        self.presenter = presenter
        self.worker = worker
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
    
    func deleteGoal(with goal: Goal) {
        worker?.deleteGoal(with: goal) { [weak self] result in
            switch result {
            case.success:
                DispatchQueue.main.async {
                    self?.presenter?.navigateToMainScreen()
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
}
