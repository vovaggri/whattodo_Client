import Foundation

enum ChangePasswordModels {
    struct Request: Decodable {
        let email: String
        let newPassword: String
        
        enum CodingKeys: String, CodingKey {
            case email
            case newPassword = "new_password"
        }
    }
}
