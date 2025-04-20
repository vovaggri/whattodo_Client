

// MARK: - Models

import UIKit
import Foundation

enum ReviewTaskModels {
    struct Request {
        let task: Task
    }

    struct Response {
        let task: Task
    }

    struct ViewModel {
        let title: String
        let description: String
        let color: UIColor
        let startTime: Date?
        let endTime: Date?
        let goalId: Int?
    }
    
    struct GoalResponse: Codable {
        var id: Int
        var title: String
        var description: String?
        var colour: Int
        var progress: Int
        var completedTasks: Int
        var totalTasks: Int
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case description
            case colour
            case progress
            case completedTasks = "completed_tasks"
            case totalTasks = "total_tasks"
        }
    }
    
    enum ReviewTaskError: Error {
        case incorrectURL
        case noData
    }
}
