import UIKit

struct Task: Codable {
    let id: Int
    var title: String
    var description: String?
    var colour: Int
    let endDate: Date
    var done: Bool
    
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
    
    func getColour() -> UIColor {
        if colour == ColorIDs.aquaBlue {
            return UIColor(hex: "DAECF3") ?? .blue
        } else if colour == ColorIDs.mossGreen {
            return UIColor(hex: "E8F9E4") ?? .green
        } else if colour == ColorIDs.marigold {
            return UIColor(hex: "F2E9D4") ?? .yellow
        } else if colour == ColorIDs.lilac {
            return UIColor(hex: "DFDFF4") ?? .purple
        } else if colour == ColorIDs.ultraPink {
            return UIColor(hex: "FCE7FF") ?? .systemPink
        } else if colour == ColorIDs.defaultWhite {
            return UIColor(hex: "F7F9F9") ?? .white
        } else {
            return .clear
        }
    }
}
