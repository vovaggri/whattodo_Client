import UIKit

final class ForgotScreenAssembly {
    static func assemble() -> ForgotScreenViewController {
        let viewController = ForgotScreenViewController()
        let interactor = ForgotScreenInteractor()
        let presenter = ForgotScreenPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
