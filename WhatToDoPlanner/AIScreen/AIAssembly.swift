import UIKit

final class AIAssembly {
    static func assembly(with goalId: Int) -> UIViewController {
        let viewController = AIVC()
        viewController.goalId = goalId
        let presenter = AIPresenter()
        let worker = AIWorker()
        let interactor = AIInteractor(presenter: presenter, worker: worker)
        
        viewController.interactor = interactor
        presenter.viewController = viewController
        return viewController
    }
}
