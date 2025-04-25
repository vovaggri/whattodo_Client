import UIKit

enum ChangeGoalAssembly {
    static func makeModule(_ goal: Goal) -> ChangeGoalViewController {
        let viewController = ChangeGoalViewController(goal: goal)
        let presenter = ChangeGoalPresenter()
        let worker = ChangeGoalWorker()
        let interactor = ChangeGoalInteractor(presenter: presenter, worker: worker)
    
        viewController.interactor = interactor
        presenter.viewController = viewController
    
        return viewController
    }
}
