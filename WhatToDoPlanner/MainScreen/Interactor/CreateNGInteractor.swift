import Foundation

protocol CreateGoalBusinessLogic {
    func fetchGoalData(request: CreateGoal.Fetch.Request)
    func uploadGoals(title: String, description: String?, color: Int)
}

final class CreateGoalInteractor: CreateGoalBusinessLogic {
    private var presenter: CreateGoalPresentationLogic?
    private var worker: CreateGoalWorkerProtocol?
    
    init(presenter: CreateGoalPresentationLogic?, worker: CreateGoalWorkerProtocol?) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func fetchGoalData(request: CreateGoal.Fetch.Request) {
        // Here you could load any default data; for now we just pass a default description.
        let response = CreateGoal.Fetch.Response(defaultDescription: "")
        presenter?.presentGoalData(response: response)
    }
    
    func uploadGoals(title: String, description: String?, color: Int) {
        let goal = CreateGoal.CreateGoalRequest(
            title: title, description: description, colour: color
        )
        
        worker?.createGoal(with: goal) { [weak self] result in
            switch result {
            case.success(let goal):
                print("Self in closure: \(String(describing: self))")
                print("Done")
                DispatchQueue.main.async {
                    self?.presenter?.navigateToGoalDetail(goal.id)
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
}
