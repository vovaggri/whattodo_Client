import UIKit

// MARK: - Assembly

enum ReviewScreenAssembly {
    static func assembly(_ task: Task) -> UIViewController {
        let presenter = ReviewTaskPresenter()
        let interactor = ReviewTaskInteractor(presenter: presenter)
        let viewController = ReviewTaskViewController(task: task)
        presenter.viewController = viewController
        viewController.interactor = interactor
        return viewController
    }
}
