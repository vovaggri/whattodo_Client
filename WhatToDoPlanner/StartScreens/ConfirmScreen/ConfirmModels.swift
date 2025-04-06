//
//  Models.swift
//  WhatToDoPlanner
//
//  Created by Vladimir Grigoryev on 03.02.2025.
//

import UIKit

enum ConfirmScreen {
    enum ScreenMessage {
        struct Request {}
        struct Response {
            let message: String
        }
        struct ViewModel {
            let message: String
        }
    }
    
    struct UserConfirmRequest {
        let email: String
        let code: String
    }
    
    struct TokenResponse: Codable {
        let token: String
    }
}
