import UIKit

// MARK: - Assembly (GoalReviewAssembly.swift)
enum GoalReviewAssembly {
    static func assembly(_ goal: Goal) -> UIViewController {
        let presenter = GoalReviewPresenter()
        let interactor = GoalReviewInteractor(presenter: presenter, goal: goal)
        let viewController = GoalReviewViewController(goal: goal)
        
        presenter.viewController = viewController
        viewController.interactor = interactor
        
        return viewController
    }
}
