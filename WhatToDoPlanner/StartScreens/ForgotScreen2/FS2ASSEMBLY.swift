import UIKit

final class ChangePasswordAssembly {
    static func assemble(email: String) -> ChangePasswordViewController {
        let interactor = ChangePasswordInteractor()
        let presenter = ChangePasswordPresenter()
        let worker = ChangePasswordWorker()
        let view = ChangePasswordViewController(interactor: interactor, email: email)

        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = view

        return view
    }
}
