protocol CreateGoalPresentationLogic {
    func presentGoalData(response: CreateGoal.Fetch.Response)
    func showErrorAlert(_ message: String?)
    func navigateToGoalDetail(_ goalId: Int)
}

final class CreateGoalPresenter: CreateGoalPresentationLogic {
    weak var viewController: CreateGoalViewController?
    
    func presentGoalData(response: CreateGoal.Fetch.Response) {
        let viewModel = CreateGoal.Fetch.ViewModel(defaultDescription: response.defaultDescription)
        viewController?.displayGoalData(viewModel: viewModel)
    }
    func navigateToGoalDetail(_ goalId: Int) {
        // pass `viewController` (which is MainScreenViewController) as the delegate
        guard let viewController = viewController else { return }
        let goalDetailVC = GoalDetailAssembly.assembly(goalId)
        
        viewController.navigationController?.pushViewController(goalDetailVC, animated: true)
//        let createTaskVC = CreateTaskAssembly.assembly(delegate: mainVC as? CreateTaskViewControllerDelegate)
//        mainVC.navigationController?.pushViewController(createTaskVC, animated: true)
    }
    
    func showErrorAlert(_ message: String?) {
        viewController?.showError(message: message ?? "Error")
    }
}
