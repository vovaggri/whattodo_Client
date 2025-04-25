import Foundation

protocol GoalReviewBusinessLogic {
    func loadGoal()
    func checkGoal(with goal: Goal)
    func deleteGoal(with goal: Goal)
    func loadTasks(with goalId: Int)
    func didSelectTask(_ selectedTask: Task)
    func updateTask(_ completedTask: Task)
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
    
    func loadTasks(with goalId: Int) {
        worker?.getTasks(with: goalId) { [weak self] result in
            switch result {
            case.success(let tasks):
                // Обновляем UI в главном потоке, если presenter работает с UI
                DispatchQueue.main.async {
                    self?.presenter?.showTasks(with: tasks)
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showTasks(with: [])
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
    
    func didSelectTask(_ selectedTask: Task) {
        presenter?.navigateToTR(selectedTask)
    }
    
    func updateTask(_ completedTask: Task) {
        worker?.updateTask(completedTask) { [weak self] result in
            switch result {
            case.success:
                DispatchQueue.main.async {
                    print("update task done")
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
}
