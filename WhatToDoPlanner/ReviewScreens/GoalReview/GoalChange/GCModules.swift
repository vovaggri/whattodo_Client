enum ChangeGoalModels {
    struct Request {
        let goal: Goal
        let name: String
        let description: String?
        let colorID: Int
    }
    struct Response {
        let goal: Goal
    }
    struct ViewModel {
        let titleText: String
        let name: String
        let description: String?
        let colorName: String
    }
}

