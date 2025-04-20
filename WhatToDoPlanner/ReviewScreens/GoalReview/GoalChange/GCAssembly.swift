import UIKit

final class ChangeGoalAssembly {
    static func make(goal: Goal) -> UIViewController {
        let changeVC = ChangeGoalViewController()
        let presenter = ChangeGoalPresenter()
        let interactor = ChangeGoalInteractor(presenter: presenter, goal: goal)
        
        changeVC.interactor = interactor
        presenter.viewController = changeVC
        
        return changeVC
    }
}
