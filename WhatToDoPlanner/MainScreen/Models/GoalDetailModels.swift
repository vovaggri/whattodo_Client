enum GoalDetail {
    enum Info {
        struct Request {}
        struct Response {
            let title: String
        }
        struct ViewModel {
            let title: String
        }
    }
    
    struct GoalResponse: Codable {
        var id: Int
        var title: String
        var description: String?
        var colour: Int
        var progress: Int
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case description
            case colour
            case progress
        }
    }
}
