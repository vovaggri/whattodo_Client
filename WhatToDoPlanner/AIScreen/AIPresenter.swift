protocol AIPresentationLogic {
    func showErrorAlert(_ message: String?)
    func showGoal(_ goal: Goal)
    func showAIAnswer(_ answer: String)
}

final class AIPresenter: AIPresentationLogic {
    weak var viewController: AIVC?
    
    func showErrorAlert(_ message: String?) {
        viewController?.showError(message: message ?? "Error")
    }
    
    func showGoal(_ goal: Goal) {
        viewController?.fillGoal(goal)
    }
    
    func showAIAnswer(_ answer: String) {
        viewController?.displayAIAnswer(answer)
    }
}
