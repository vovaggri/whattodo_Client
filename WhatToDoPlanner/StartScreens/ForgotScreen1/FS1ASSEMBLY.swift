import UIKit

final class ForgotScreenAssembly {
    static func assemble() -> ForgotScreenViewController {
        let viewController = ForgotScreenViewController()
        let interactor = ForgotScreenInteractor()
        let presenter = ForgotScreenPresenter()
        let worker = ForgotScreenWorker()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        
        return viewController
    }
}
