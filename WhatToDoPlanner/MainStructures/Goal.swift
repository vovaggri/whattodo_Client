import Foundation
import UIKit

struct Goal: Codable, Equatable {
    let id: Int
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
    
    static func ==(lhs: Goal, rhs: Goal) -> Bool {
        return lhs.title == rhs.title
        && lhs.description == rhs.description
        && lhs.colour == rhs.colour
    }
}
