import UIKit

final class ChangeTaskAssembly {
    static func assembly() -> changeTaskViewController {
        let viewController = changeTaskViewController()
        let interactor = ChangeTaskInteractor()
        let presenter = ChangeTaskPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
