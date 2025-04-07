import Foundation

struct Goal: Codable {
    let id: Int
    var title: String
    var description: String?
    var colour: Int
    var progress: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case colour
        case progress
    }
}
