import Foundation

/// Stub worker to send your “create goal” request.
final class CreateNewGoalWorker {
  func createGoal(name: String,
                  description: String,
                  color: String,
                  completion: @escaping (CreateNewGoalModels.Create.Response) -> Void) {
    // TODO: hook up your API / DB save here
    let success = true
    let resp = CreateNewGoalModels.Create.Response(
      success: success,
      errorMessage: success ? nil : "Failed to create goal"
    )
    completion(resp)
  }
}
