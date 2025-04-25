enum ForgotScreen {
    enum Fetch {
        struct Request: Decodable {
            let email: String
            
            enum CodingKeys: String, CodingKey {
                case email
            }
        }
        struct Response {
            let emailPlaceholder: String
        }
        struct ViewModel {
            let emailPlaceholder: String
        }
    }
}
