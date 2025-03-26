import Foundation

protocol CalendarInteractorProtocol {
    
}

final class CalendarInteractor: CalendarInteractorProtocol {
    private var presenter: CalendarPresenterProtocol?
    private var worker: CalendarWorkerProtocol?
    
    init(presenter: CalendarPresenterProtocol?, worker: CalendarWorkerProtocol?) {
        self.presenter = presenter
        self.worker = worker
    }
}

