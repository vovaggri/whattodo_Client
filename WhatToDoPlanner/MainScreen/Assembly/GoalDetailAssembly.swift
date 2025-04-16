// MARK: - Assembly
//enum GoalDetailAssembly {
//    static func assembly() -> UIViewController{
//        let viewController = GoalDetailViewController()
//        let presenter = GoalDetailPresenter()
//        let interactor = GoalDetailInteractor()
//
//        viewController.interactor = interactor
//        interactor.presenter = presenter
//        presenter.viewController = viewController
//
//        return viewController
//    }
//}
final class GoalDetailAssembly  {
    static func assembly(_ goalId: Int) -> GoalDetailViewController {
        let viewController = GoalDetailViewController()
        let presenter = GoalDetailPresenter()
        let worker = GoalDetailWorker()
        let interactor = GoalDetailInteractor(presenter: presenter, worker: worker)
        
        viewController.interactor = interactor
        viewController.goalId = goalId
        presenter.viewController = viewController
        
        return viewController
    }
}
