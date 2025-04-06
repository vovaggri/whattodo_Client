import UIKit

final class ChangePasswordAssembly {
    static func assemble() -> ChangePasswordViewController {
        let view = ChangePasswordViewController()
        let interactor = ChangePasswordInteractor()
        let presenter = ChangePasswordPresenter()

        view.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = view

        return view
    }
}
