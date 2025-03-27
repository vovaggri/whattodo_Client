import Foundation

final class CalendarAssembly {
    static func assembly() -> CalendarViewController {
        let vc = CalendarViewController()
        let presenter = CalendarPresenter()
        let worker = CalendarWorker()
        let interactor = CalendarInteractor(presenter: presenter, worker: worker)
        
        vc.interactor = interactor
        presenter.viewController = vc
        
        return vc
    }
}
