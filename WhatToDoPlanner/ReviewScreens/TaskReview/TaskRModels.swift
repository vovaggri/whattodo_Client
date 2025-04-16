

// MARK: - Models

import UIKit
import Foundation

enum ReviewTaskModels {
    struct Request {
        let task: Task
    }

    struct Response {
        let task: Task
    }

    struct ViewModel {
        let title: String
        let description: String
        let color: UIColor
        let startTime: String?
        let endTime: String?
        let goalId: Int?
    }
}
