import Foundation

enum CreateTaskModels {
    struct CreateTaskRequest: Codable {
        var title: String
        var description: String?
        var colour: Int
        var endDate: Date
        var done: Bool
        var startTime: Date?
        var endTime: Date?
        
        enum CodingKeys: String, CodingKey {
            case title, description, colour
            case endDate = "end_date"
            case done, startTime = "start_time", endTime = "end_time"
        }
    }
    
    struct CreateTaskResponse: Codable {
        let id: Int
    }
    
    enum CreateTaskError: Error {
        case incorrectURL
        case noData
    }
}

