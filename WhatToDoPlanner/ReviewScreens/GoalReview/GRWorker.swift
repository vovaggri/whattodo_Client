import Foundation

protocol GoalReviewWorkerProtocol {
    func deleteGoal(with goal: Goal, completion: @escaping (Result<Void, Error>) -> Void)
}

final class GoalReviewWorker: GoalReviewWorkerProtocol {
    private let keychainService = KeychainService()
    private let baseUrl: String = Server.url
    
    func deleteGoal(with goal: Goal, completion: @escaping (Result<Void, any Error>) -> Void) {
        let urlText: String = baseUrl + "/api/goal/\(goal.id)"
        
        guard let url = URL(string: urlText) else {
            print("Incorrect URL")
            completion(.failure(NSError(domain: "DeleteGoal", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        // Указываем, что тело запроса в формате JSON
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let tokenData = keychainService.getData(forKey: "userToken"), let token = String(data: tokenData, encoding: .utf8) {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data on answer")
                completion(.failure(NSError(domain: "DeleteGoal", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")
                if jsonString == "null" {
                    print("Empty profile")
                    completion(.failure(NSError(domain: "DeleteGoal", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                    return
                }
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let answerBody = try decoder.decode(GoalReviewModels.DeleteResponse.self, from: data)
                print("Status: \(answerBody)")
                completion(.success(()))
            } catch {
                print("Error while decoding data: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
