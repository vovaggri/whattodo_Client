protocol ChangeGoalBusinessLogic {
    func loadGoal()
    func saveChanges(goalName: String, description: String?, colorID: Int)
}

final class ChangeGoalInteractor: ChangeGoalBusinessLogic {
    private let presenter: ChangeGoalPresentationLogic?
    private var goal: Goal
    
    init(presenter: ChangeGoalPresenter, goal: Goal) {
        self.presenter = presenter
        self.goal = goal
    }
    
    func loadGoal() {
        let vm = ChangeGoalModels.ViewModel(
            titleText: "Change Goal",
            name: goal.title,
            description: goal.description,
            colorName: name(for: goal.colour)
        )
        presenter?.presentGoal(
            response: ChangeGoalModels.Response(goal: goal),
            viewModel: vm
        )
    }
    
    func saveChanges(goalName: String, description: String?, colorID: Int) {
        // Update goal model
        goal.title = goalName
        goal.description = description
        goal.colour = colorID
        // In a real app, persist changes here
        let vm = ChangeGoalModels.ViewModel(
               titleText: "Change Goal",
               name: goalName,
               description: description,
               colorName: name(for: colorID)
           )
           presenter?.presentGoal(
               response: ChangeGoalModels.Response(goal: goal),
               viewModel: vm
           )
    }
    
    private func name(for colorID: Int) -> String {
        switch colorID {
        case ColorIDs.aquaBlue: return "Aqua Blue"
        case ColorIDs.mossGreen: return "Moss Green"
        case ColorIDs.marigold: return "Marigold"
        case ColorIDs.lilac: return "Lilac"
        case ColorIDs.ultraPink: return "Ultra Pink"
        case ColorIDs.defaultWhite: return "Default White"
        default: return "Unknown"
        }
    }
}
