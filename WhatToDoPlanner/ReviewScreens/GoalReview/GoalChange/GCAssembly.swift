import UIKit

enum CreateNewGoalAssembly {
  static func makeModule() -> CreateNewGoalViewController {
    let viewController = CreateNewGoalViewController()
    let interactor    = CreateNewGoalInteractor()
    let presenter     = CreateNewGoalPresenter()
    
    viewController.interactor               = interactor
    interactor.presenter                    = presenter
    presenter.viewController                = viewController
    
    return viewController
  }
}
