import Foundation

// MARK: - Module Definition
enum CreateGTask {
    enum Fetch {
        struct Request: Codable {
            var title: String
            var description: String?
            var colour: Int
            var endDate: Date
            
            var startTime: Date?
            var endTime: Date?
            
            enum CodingKeys: String, CodingKey {
                case title, description, colour
                case endDate = "end_date"
                case startTime = "start_time"
                case endTime = "end_time"
            }
        }
        struct Response: Codable {
            var id: Int
            
            enum CodingKeys: String, CodingKey {
                case id
            }
        }
        struct ViewModel {
            let defaultDescription: String
        }
    }
}
