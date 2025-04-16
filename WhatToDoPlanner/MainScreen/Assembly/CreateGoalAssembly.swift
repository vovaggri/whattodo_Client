import UIKit

final class CreateGoalAssembly {
    static func assembly() -> CreateGoalViewController {
        let viewController = CreateGoalViewController()
        let presenter = CreateGoalPresenter()
        let worker = CreateGoalWorker()
        let interactor = CreateGoalInteractor(presenter: presenter, worker: worker)
        
        viewController.interactor = interactor
        presenter.viewController = viewController
        
        return viewController
    }
}

