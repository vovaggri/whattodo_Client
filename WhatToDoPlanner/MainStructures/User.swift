import Foundation

struct User: Codable {
    let id: Int?
    let firstName: String
    let secondName: String
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case secondName = "second_name"
        case email
        case password
    }
}
