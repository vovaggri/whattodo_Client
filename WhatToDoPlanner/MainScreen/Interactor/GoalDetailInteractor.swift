import Foundation

protocol GoalDetailBusinessLogic {
    func fetchGoalInfo(with goalId: Int)
    func loadTasks(with goalId: Int)
    func deleteTask(with taskId: Int)
}

final class GoalDetailInteractor: GoalDetailBusinessLogic {
    private var presenter: GoalDetailPresentationLogic?
    private var worker: GoalDetailWorkerProtocol?
    
    init(presenter: GoalDetailPresentationLogic?, worker: GoalDetailWorkerProtocol?) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func fetchGoalInfo(with goalId: Int) {
        worker?.loadGoal(with: goalId) { [weak self] result in
            switch result {
            case.success(let goalResponse):
                print("Self in closure: \(String(describing: self))")
                print("Done")
                DispatchQueue.main.async {
                    let goal: Goal = Goal(id: goalResponse.id, title: goalResponse.title, description: goalResponse.description, colour: goalResponse.colour, completedTasks: goalResponse.completedTasks, totalTasks: goalResponse.totalTasks)
                    
                    self?.presenter?.presentGoalInfo(response: goal)
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
    
    func deleteTask(with taskId: Int) {
        worker?.removeTask(with: taskId) { [weak self] result in
            switch result {
            case.success():
                DispatchQueue.main.async {
                    print("Deleted successfully")
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
}
