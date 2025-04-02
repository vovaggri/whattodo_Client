import Foundation

struct Task: Codable {
    let id: Int
    var title: String
    var description: String?
    var colour: Int
    let endDate: Date
    let done: Bool
    
    // Optional
    var startTime: Date?
    var endTime: Date?
    
    var goalId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case colour
        case endDate = "end_date"
        case done
        case startTime = "start_time"
        case endTime = "end_time"
        case goalId = "goal_id"
    }
}
