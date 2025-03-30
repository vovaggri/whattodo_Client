protocol CreateGoalBusinessLogic {
    func fetchGoalData(request: CreateGoal.Fetch.Request)
}

final class CreateGoalInteractor: CreateGoalBusinessLogic {
    var presenter: CreateGoalPresentationLogic?
    
    func fetchGoalData(request: CreateGoal.Fetch.Request) {
        // Here you could load any default data; for now we just pass a default description.
        let response = CreateGoal.Fetch.Response(defaultDescription: "Enter your goal description here...")
        presenter?.presentGoalData(response: response)
    }
    
   
}
