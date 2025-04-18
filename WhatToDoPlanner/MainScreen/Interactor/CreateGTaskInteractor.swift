import UIKit

protocol CreateGTaskBusinessLogic {
    func fetchTaskData(title: String, date: Date, color: Int, goalId: Int, description: String?, startTime: Date?, endTime: Date?)
}

final class CreateGTaskInteractor: CreateGTaskBusinessLogic {
    private var presenter: CreateGTaskPresentationLogic?
    private var worker: CreateGTaskWorkerProtocol?
    
    init(presenter: CreateGTaskPresentationLogic?, worker: CreateGTaskWorkerProtocol?) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func fetchTaskData(title: String, date: Date, color: Int, goalId: Int, description: String?, startTime: Date?, endTime: Date?) {
        let fixedStartTime = fixedDate(from: startTime)
        let fixedEndTime = fixedDate(from: endTime)
        
        let task = CreateGTask.Fetch.Request(title: title, description: description, colour: color, endDate: date, startTime: fixedStartTime, endTime: fixedEndTime)
        
        worker?.createTask(with: task, goalId: goalId) { [weak self] result in
            switch result {
            case.success:
                print("Self in closure: \(String(describing: self))")
                print("Done")
                DispatchQueue.main.async {
                    self?.presenter?.returnToDetailScreen()
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
            
        }
        
        print("done")
        
//        // In a real application, you could load or process data here.
//        let response = CreateGTask.Fetch.Response(defaultDescription: "")
//        presenter?.presentTaskData(response: response)
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
