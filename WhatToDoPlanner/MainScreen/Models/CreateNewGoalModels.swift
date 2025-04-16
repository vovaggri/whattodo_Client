import UIKit

enum CreateGoal {
    enum Fetch {
        struct Request { }
        struct Response {
            let defaultDescription: String
        }
        struct ViewModel {
            let defaultDescription: String
        }
    }
    
    enum CreateGoalError: Error {
        case incorrectURL
        case noData
    }
    
    struct CreateGoalRequest: Codable {
        var title: String
        var description: String?
        var colour: Int
        
        enum CodingKeys: String, CodingKey {
            case title
            case description
            case colour
        }
    }
    
    struct CreateGoalResponse: Codable {
        let id: Int
    }
}
