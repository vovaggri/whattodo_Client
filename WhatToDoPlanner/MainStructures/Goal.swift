import Foundation

struct Goal: Codable {
    let id: Int
    var title: String
    var description: String?
    var tasks: [Task]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case tasks
    }
}
