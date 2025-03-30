import UIKit

final class CreateGTaskPresenter: CreateGTaskPresentationLogic {
    weak var viewController: CreateGTaskDisplayLogic?
    
    func presentTaskData(response: CreateGTask.Fetch.Response) {
        let viewModel = CreateGTask.Fetch.ViewModel(defaultDescription: response.defaultDescription)
        viewController?.displayTaskData(viewModel: viewModel)
    }
    
    func navigateToTaskDetail() {
        guard let vc = viewController as? UIViewController else { return }
        // Call the correct assembly for the Task Detail screen
        let taskDetailVC = CreateGTaskAssembly.assembly() // Ensure this assembly returns your Task Detail screen
        vc.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
}
