import Foundation

protocol ChangeTaskBusinessLogic {
    func loadGoals()
    func updateTask(id: Int, title: String, date: Date, color: Int, description: String?, startTime: Date?, endTime: Date?, goalId: Int?)
}

final class ChangeTaskInteractor: ChangeTaskBusinessLogic {
    var presenter: ChangeTaskPresentationLogic?
    var worker: ChangeTaskWorkerProtocol?
    
    func loadGoals() {
        worker?.getGoals { [weak self] result in
            switch result {
            case.success(let goals):
                DispatchQueue.main.async {
                    self?.presenter?.showGoals(with: goals)
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showGoals(with: [])
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
    
    func updateTask(id: Int, title: String, date: Date, color: Int, description: String?, startTime: Date?, endTime: Date?, goalId: Int?) {
        let fixedStartTime = fixedDate(from: startTime)
        let fixedEndTime = fixedDate(from: endTime)
        
        let task = CreateTaskModels.CreateTaskRequest(
            title: title,
            description: description,
            colour: color,
            endDate: date,
            done: false,
            startTime: fixedStartTime,
            endTime: fixedEndTime
        )
        
        worker?.updateTask(id: id, with: task, goalId: goalId ?? 0) { [weak self] result in
            switch result {
            case.success:
                print("Task updated")
                DispatchQueue.main.async {
                    self?.presenter?.navigateMainScreen()
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
    
    private func fixedDate(from date: Date?) -> Date? {
        guard let date = date else { return nil }
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        if let year = components.year, year == 0 {
            components.year = 1970
            return calendar.date(from: components)
        }
        return date
    }
}
