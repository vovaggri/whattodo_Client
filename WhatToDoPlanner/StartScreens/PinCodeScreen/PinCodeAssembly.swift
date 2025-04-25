import UIKit

final class PinCodeAssembly {
    static func assemble(email: String) -> PinCodeViewController {
        let interactor = PinCodeInteractor()
        let presenter = PinCodePresenter()
        let worker = PinCodeWorker()
        let view = PinCodeViewController(email: email, interactor: interactor)

        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = view

        return view
    }
}
