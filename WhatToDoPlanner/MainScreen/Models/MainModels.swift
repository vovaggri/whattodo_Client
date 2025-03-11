import UIKit

enum MainScreen {
    
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



    }
}
 
