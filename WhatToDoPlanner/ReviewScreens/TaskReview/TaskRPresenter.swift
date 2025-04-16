protocol ReviewTaskPresentationLogic {
    func presentTask(response: ReviewTaskModels.Response, startTime: String?, endTime: String?)
}

final class ReviewTaskPresenter: ReviewTaskPresentationLogic {
    weak var viewController: ReviewTaskDisplayLogic?

    func presentTask(response: ReviewTaskModels.Response, startTime: String?, endTime: String?) {
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
}
