// MARK: - Interactor
import UIKit
protocol ReviewTaskBusinessLogic {
    func loadTask(request: ReviewTaskModels.Request)
}

final class ReviewTaskInteractor: ReviewTaskBusinessLogic {
    private let presenter: ReviewTaskPresentationLogic

    init(presenter: ReviewTaskPresentationLogic) {
        self.presenter = presenter
    }

    func loadTask(request: ReviewTaskModels.Request) {
        let task = request.task

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        let startTime = task.startTime.map { formatter.string(from: $0) }
        let endTime = task.endTime.map { formatter.string(from: $0) }

        let response = ReviewTaskModels.Response(task: task)
        presenter.presentTask(response: response, startTime: startTime, endTime: endTime)
    }
}
