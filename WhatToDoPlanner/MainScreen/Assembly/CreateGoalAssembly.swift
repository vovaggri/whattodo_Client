import UIKit

final class CreateGoalAssembly {
    static func assemble() -> CreateGoalViewController {
        let viewController = CreateGoalViewController()
        let interactor = CreateGoalInteractor()
        let presenter = CreateGoalPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}

