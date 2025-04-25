// MARK: - Interactor
import UIKit
protocol ReviewTaskBusinessLogic {
    func loadTask(request: ReviewTaskModels.Request)
    func getGoal(with goalId: Int)
    func deleteTask(with task: Task)
}

final class ReviewTaskInteractor: ReviewTaskBusinessLogic {
    private let presenter: ReviewTaskPresentationLogic?
    private let worker: ReviewTaskWorkerProtocol?

    init(presenter: ReviewTaskPresentationLogic?, worker: ReviewTaskWorkerProtocol?) {
        self.presenter = presenter
        self.worker = worker
    }

    func loadTask(request: ReviewTaskModels.Request) {
        let task = request.task

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        let response = ReviewTaskModels.Response(task: task)
        presenter?.presentTask(response: response, startTime: task.startTime, endTime: task.endTime)
    }
    
    func getGoal(with goalId: Int) {
        if goalId == 0 {
            presenter?.presentGoalTitle(with: "No goal")
        } else {
            worker?.loadGoal(with: goalId) { [weak self] result in
                switch result {
                case.success(let responseGoal):
                    DispatchQueue.main.async {
                        let textTitleGoal = responseGoal.title
                        self?.presenter?.presentGoalTitle(with: textTitleGoal)
                    }
                case.failure(let error):
                    DispatchQueue.main.async {
                        self?.presenter?.showErrorAlert(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func deleteTask(with task: Task) {
        worker?.deleteTask(with: task) { [weak self] result in
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
