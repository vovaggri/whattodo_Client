import UIKit

class SuccessScreenConfigurator {
    static func configureModule() -> UIViewController {
        let interactor = SuccessScreenInteractor()
        let presenter = SuccessScreenPresenter()
        let router = SuccessScreenRouter()
        
        let viewController = SuccessScreenViewController(interactor: interactor)
        
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        
        return viewController
    }
}
