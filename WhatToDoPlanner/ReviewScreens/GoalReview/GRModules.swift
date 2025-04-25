import UIKit

enum GoalReviewModels {
    struct Request {
        let goal: Goal
    }
    
   
    
    struct ViewModel {
        let title: String
        let color: UIColor
    }
    struct Response {
        let success: Bool
    }
    
    struct DeleteResponse: Decodable {
        let status: String
        
        enum CodingKeys: String, CodingKey {
            case status
        }
    }
}
