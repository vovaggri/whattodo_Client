import UIKit

enum ChangeUsernameModuleAssembler {
  static func build() -> UIViewController {
    let vc         = ChangeUsernameViewController()
    let interactor = ChangeUsernameInteractor()
    let presenter  = ChangeUsernamePresenter()

    vc.interactor          = interactor
    interactor.presenter   = presenter
    presenter.viewController = vc

    return vc
  }
}
