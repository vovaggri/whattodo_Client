protocol ChangeTaskBusinessLogic {
    func uploadTask(request: ChangeTaskModels.Request)
}

final class ChangeTaskInteractor: ChangeTaskBusinessLogic {
    var presenter: ChangeTaskPresentationLogic?

    func uploadTask(request: ChangeTaskModels.Request) {
        print("Uploading task:", request)
        presenter?.presentTaskUpload(response: ChangeTaskModels.Response(success: true))
    }
}
