import Foundation

protocol AIBusinessLogic {
//    func getGoal(with goalId: Int)
    func fetchGoalInfo(with goalId: Int)
    func fetchAIAnswer(with goalId: Int)
}

final class AIInteractor: AIBusinessLogic {
    private var presenter: AIPresentationLogic?
    private var worker: AIWorkerProtocol?
    
    init(presenter: AIPresentationLogic?, worker: AIWorkerProtocol?) {
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
                    let goal: Goal = Goal(id: goalResponse.id, title: goalResponse.title, description: goalResponse.description, colour: goalResponse.colour, progress: goalResponse.progress, completedTasks: goalResponse.completedTasks, totalTasks: goalResponse.totalTasks)
                    
                    self?.presenter?.showGoal(goal)
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchAIAnswer(with goalId: Int) {
        worker?.loadAIResponse(with: goalId) { [weak self] result in
            switch result {
            case.success(let answer):
                DispatchQueue.main.async {
                    self?.presenter?.showAIAnswer(answer)
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
}
