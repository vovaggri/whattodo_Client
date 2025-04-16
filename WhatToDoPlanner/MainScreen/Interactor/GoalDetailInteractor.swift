import Foundation

protocol GoalDetailBusinessLogic {
    func fetchGoalInfo(with goalId: Int)
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
                    let goal: Goal = Goal(id: goalResponse.id, title: goalResponse.title, description: goalResponse.description, colour: goalResponse.colour)
                    
                    self?.presenter?.presentGoalInfo(response: goal)
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
}
