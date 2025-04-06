import Foundation

enum BottomModels{
    struct TaskResponse: Codable {
        let results: [Task]
    }
    
    struct updateTaskRequest: Codable {
        let done: Bool
    }
    
    struct updateTaskResponse: Codable {
        let status: String
    }
}
