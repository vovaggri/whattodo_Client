import UIKit

enum MainModels {
    
    // MARK: - Nested Types
    enum Fetch {
        struct Request { }
        struct Response {
            let greeting: String
            let avatar: UIImage?
            let categories: [CategoryViewModel]
            //            let tasks: [TaskItem]
        }
        struct ViewModel {
            let greetingText: String
            let avatarImage: UIImage?
            let categories: [CategoryViewModel] 
            //            let tasks: [TaskViewModel]
        }


        struct CategoryViewModel {
            let title: String
            let progressText: String
            let progressValue: Float
            let color: UIColor
        }

        struct UserResponse: Codable {
            let email: String
            let firstName: String
            let secondName: String
            
            enum CodingKeys: String, CodingKey {
                case email
                case firstName = "first_name"
                case secondName = "second_name"
            }
        }
        
        enum MainError: Error {
            case incorrectURL
            case noKeychain
            case noData
        }

    }
}
 
