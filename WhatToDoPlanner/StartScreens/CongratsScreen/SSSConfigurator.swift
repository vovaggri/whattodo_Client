import UIKit

final class SuccessScreenConfigurator {
    static func configureModule() -> UIViewController {
        let interactor = SuccessScreenInteractor()
        let presenter = SuccessScreenPresenter()
        
        let viewController = SuccessScreenViewController(interactor: interactor)
        
        interactor.presenter = presenter
        presenter.viewController = viewController        
        return viewController
    }
}
