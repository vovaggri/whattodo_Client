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
    static func assembly() -> GoalDetailViewController {
        let viewController = GoalDetailViewController()
        let interactor = GoalDetailInteractor()
        let presenter = GoalDetailPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
