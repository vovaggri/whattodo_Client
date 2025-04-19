import UIKit

protocol CreateGTaskPresentationLogic {
    func returnToDetailScreen()
    func showErrorAlert(_ message: String?)
    func navigateToTaskDetail()
}

final class CreateGTaskPresenter: CreateGTaskPresentationLogic {
    weak var viewController: CreateGTaskViewController?
    
    func returnToDetailScreen() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func showErrorAlert(_ message: String?) {
        viewController?.showError(message: message ?? "Error")
    }
    
    func navigateToTaskDetail() {
        guard let vc = viewController as? UIViewController else { return }
        // Call the correct assembly for the Task Detail screen
//        let taskDetailVC = CreateGTaskAssembly.assembly() // Ensure this assembly returns your Task Detail screen
//        vc.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
}
