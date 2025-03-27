import Foundation

protocol CalendarPresenterProtocol {
    func presentCalendar(title: String, weeks: [[CalendarModels.CalendarDay]])
}

final class CalendarPresenter: CalendarPresenterProtocol {
    weak var viewController: CalendarViewController?
    
    func presentCalendar(title: String, weeks: [[CalendarModels.CalendarDay]]) {
        let viewModel = CalendarModels.CalendarViewModel(title: title, weeks: weeks)
        viewController?.displayCalendar(viewModel: viewModel)
    }
}
