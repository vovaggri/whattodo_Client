import UIKit

final class CreateGTaskInteractor: CreateGTaskBusinessLogic {
    var presenter: CreateGTaskPresentationLogic?
    
    func fetchTaskData(request: CreateGTask.Fetch.Request) {
        // In a real application, you could load or process data here.
        let response = CreateGTask.Fetch.Response(defaultDescription: "Enter your task description here...")
        presenter?.presentTaskData(response: response)
    }
}
