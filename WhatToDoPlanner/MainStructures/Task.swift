import Foundation

struct Task: Codable {
    let id: Int
    var title: String
    var description: String?
    let date: Date
    let done: Bool
    
    // Optional
    var startTime: Date?
    var endTime: Date?
    
    var goalId: Int?
    
    enum CodengKeys: String, CodingKey {
        case id
        case title
        case description
        case date
        case startTime
        case endTime
        case goalId
    }
}
