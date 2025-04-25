import UIKit

final class ChangeTaskAssembly {
    static func assembly(_ task: Task) -> ChangeTaskViewController {
        let viewController = ChangeTaskViewController(task: task)
        let interactor = ChangeTaskInteractor()
        let presenter = ChangeTaskPresenter()
        let worker = ChangeTaskWorker()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        
        return viewController
    }
}
