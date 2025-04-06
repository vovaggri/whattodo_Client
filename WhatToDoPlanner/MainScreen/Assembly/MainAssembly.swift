//
//  MainAssembly.swift

import UIKit

final class MainAssembly {
    static func assembly() -> UIViewController {
        let viewController = MainScreenViewController()
        let presenter = MainScreenPresenter()
        let worker = MainWorker()
        let interactor = MainScreenInteractor(presenter: presenter, worker: worker)
        
        viewController.interactor = interactor
        presenter.viewController = viewController
        
        return viewController
    }
}
