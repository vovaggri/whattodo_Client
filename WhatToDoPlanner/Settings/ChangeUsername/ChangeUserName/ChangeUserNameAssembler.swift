import UIKit

enum ChangeUsernameModuleAssembler {
    static func build(firstName: String, secondName: String) -> UIViewController {
        let vc = ChangeUsernameViewController()
        let presenter  = ChangeUsernamePresenter()
        let worker = ChangeUsernameWorker()
        let interactor = ChangeUsernameInteractor(presenter: presenter, worker: worker, currentFirstName: firstName, currentLastName: secondName)

        vc.interactor = interactor
        presenter.viewController = vc

        return vc
    }
}
