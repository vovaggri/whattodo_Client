import UIKit

enum CreateNewGoalModels {
  
  // MARK: Load Blank Screen
  enum Load {
    struct Request { }
    struct Response {
      let title: String
      let namePlaceholder: String
      let descriptionPlaceholder: String
      let colorPlaceholder: String
    }
    struct ViewModel {
      let title: String
      let namePlaceholder: String
      let descriptionPlaceholder: String
      let colorPlaceholder: String
    }
  }
  
  // MARK: Create Action
  enum Create {
    struct Request {
      let name: String
      let description: String
      let color: String
    }
    struct Response {
      let success: Bool
      let errorMessage: String?
    }
    struct ViewModel {
      let alertTitle: String
      let alertMessage: String
    }
  }
}
