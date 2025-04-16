import Foundation

enum ChangeTaskModels {
    
    struct Request {
        let title: String
        let description: String?
        let colour: Int
        let endDate: Date
        let done: Bool
        let startTime: Date?
        let endTime: Date?
        let goalId: Int?
    }
    
    struct Response {
        let success: Bool
    }
    
    struct ViewModel {
        let message: String
    }
    
    enum Error: Swift.Error {
        case networkError
        case validationError
    }
}
