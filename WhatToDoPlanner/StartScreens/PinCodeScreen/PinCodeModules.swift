//
//  Models.swift
//  WhatToDoPlanner
//
//  Created by Vladimir Grigoryev on 03.02.2025.
//

import UIKit

enum PinCodeScreen {
    enum ScreenMessage {
        struct Request {}
        struct Response {
            let message: String
        }
        struct ViewModel {
            let message: String
        }
    }
}
