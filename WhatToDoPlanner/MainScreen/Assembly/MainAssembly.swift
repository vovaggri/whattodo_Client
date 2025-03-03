//
//  MainAssembly.swift

import UIKit

final class MainAssembly {
    static func assembly() -> UIViewController {
        let viewController = MainScreenViewController()
        let presenter = MainScreenPresenter()
        let interactor = MainScreenInteractor(presenter: presenter)
        
        viewController.interactor = interactor
        presenter.viewController = viewController
        
        return viewController
    }
}
