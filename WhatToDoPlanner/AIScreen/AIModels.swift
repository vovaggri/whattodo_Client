enum AIModels {
    struct AIResponse: Codable {
        var advice: String
        
        enum CodingKeys: String, CodingKey {
            case advice
        }
    }
    
    enum AIError: Error {
        case incorrectURL
        case noData
    }
}
