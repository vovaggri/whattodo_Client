import Foundation

final class ChangeGoalInteractor: ChangeGoalBusinessLogic {
    private var presenter: ChangePresentationLogic?
    private var worker: ChangeGoalWorkerProtocol?
    
    init(presenter: ChangePresentationLogic?, worker: ChangeGoalWorkerProtocol?) {
        self.presenter = presenter
        self.worker = worker
    }

    func changeGoal(id: Int, title: String, description: String, color: Int) {
        let goal = CreateGoal.CreateGoalRequest(
            title: title, description: description, colour: color
        )
        
        worker?.updateGoal(id: id, with: goal) { [weak self] result in
            switch result {
            case.success:
                print("Goal updated")
                DispatchQueue.main.async {
                    self?.presenter?.navigateMainScreen()
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
}
