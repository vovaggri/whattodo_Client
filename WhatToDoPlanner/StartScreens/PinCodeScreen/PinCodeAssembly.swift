import UIKit

final class PinCodeAssembly {
    static func assemble() -> PinCodeViewController {
        let interactor = PinCodeInteractor()
        let presenter = PinCodePresenter()
        let view = PinCodeViewController(interactor: interactor)

        view.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = view

        return view
    }
}
