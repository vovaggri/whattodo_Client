protocol CreateGoalPresentationLogic {
    func presentGoalData(response: CreateGoal.Fetch.Response)
}

final class CreateGoalPresenter: CreateGoalPresentationLogic {
    weak var viewController: CreateGoalDisplayLogic?
    
    func presentGoalData(response: CreateGoal.Fetch.Response) {
        let viewModel = CreateGoal.Fetch.ViewModel(defaultDescription: response.defaultDescription)
        viewController?.displayGoalData(viewModel: viewModel)
    }
    func navigateToGoalDetail() {
        // pass `viewController` (which is MainScreenViewController) as the delegate
        guard let mainVC = viewController else { return }
//        let createTaskVC = CreateTaskAssembly.assembly(delegate: mainVC as? CreateTaskViewControllerDelegate)
//        mainVC.navigationController?.pushViewController(createTaskVC, animated: true)
    }
}
