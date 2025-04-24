import UIKit

final class SettingsAssembly {
    static func assembly() -> UIViewController {
        let viewController = SettingsVC()
        let presenter = SettingsPresenter()
        let worker = SettingsWorker()
        let interactor = SettingsInteractor(presenter: presenter, worker: worker)
        
        viewController.interactor = interactor
        presenter.viewController = viewController
        
        return viewController
    }
}
