import Foundation

protocol CalendarPresenterProtocol {
    func presentCalendar(title: String, weeks: [[CalendarModels.CalendarDay]])
    func presentTasks(with tasks: [Task])
    func showAlertError(message: String)
}

final class CalendarPresenter: CalendarPresenterProtocol {
    weak var viewController: CalendarViewController?
    
    func presentCalendar(title: String, weeks: [[CalendarModels.CalendarDay]]) {
        let viewModel = CalendarModels.CalendarViewModel(title: title, weeks: weeks)
        viewController?.displayCalendar(viewModel: viewModel)
    }
    
    func presentTasks(with tasks: [Task]) {
        viewController?.allTasks = tasks
    }
    
    func showAlertError(message: String) {
        viewController?.displayError(message: message)
    }
}
