protocol GoalDetailBusinessLogic {
    func fetchGoalInfo(request: GoalDetail.Info.Request)
}

final class GoalDetailInteractor: GoalDetailBusinessLogic {
    var presenter: GoalDetailPresentationLogic?
    
    func fetchGoalInfo(request: GoalDetail.Info.Request) {
        let response = GoalDetail.Info.Response(title: "IOS dev")
        presenter?.presentGoalInfo(response: response)
        
    }
}
