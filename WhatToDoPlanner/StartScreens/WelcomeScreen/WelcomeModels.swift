enum WelcomeModels {
    struct User {
        let email: String
        let password: String
        
        init(email: String, password: String) {
            self.email = email
            self.password = password
        }
    }
    
    struct TokenResponse: Codable {
        let token: String
    }
}

