import Foundation

enum CreateTaskModels {
    struct CreateTaskRequest: Codable {
        let title: String
        let description: String?
        let date: Date
        let startTime: Date?
        let endTime: Date?
        let goalId: Int?
    }
    
    enum CreateTaskError: Error {
        case incorrectURL
        case noData
    }
}

