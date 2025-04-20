import Foundation
protocol ReviewTaskPresentationLogic {
    func presentTask(response: ReviewTaskModels.Response, startTime: Date?, endTime: Date?)
    func presentGoalTitle(with text: String)
    func showErrorAlert(_ message: String?)
}

final class ReviewTaskPresenter: ReviewTaskPresentationLogic {
    weak var viewController: ReviewTaskViewController?

    func presentTask(response: ReviewTaskModels.Response, startTime: Date?, endTime: Date?) {
        let task = response.task
        let viewModel = ReviewTaskModels.ViewModel(
            title: task.title,
            description: task.description ?? "No description",
            color: task.getColour(),
            startTime: startTime,
            endTime: endTime,
            goalId: task.goalId
            // Replace this with real goal name lookup if needed
        )
        viewController?.displayTask(viewModel: viewModel)
    }
    
    func presentGoalTitle(with text: String) {
        viewController?.displayGoalText(with: text)
    }
    
    func showErrorAlert(_ message: String?) {
        viewController?.showError(message: message ?? "Error")
    }
}
