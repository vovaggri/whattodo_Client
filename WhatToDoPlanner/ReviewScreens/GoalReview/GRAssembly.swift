import UIKit

// MARK: - Assembly (GoalReviewAssembly.swift)
enum GoalReviewAssembly {
    static func assembly(_ goal: Goal) -> UIViewController {
        let presenter = GoalReviewPresenter()
        let worker = GoalReviewWorker()
        let interactor = GoalReviewInteractor(presenter: presenter, worker: worker, goal: goal)
        let viewController = GoalReviewViewController(goal: goal)
        
        presenter.viewController = viewController
        viewController.interactor = interactor
        
        return viewController
    }
}
