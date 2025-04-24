import Foundation

protocol ReviewTaskWorkerProtocol {
    func loadGoal(with goalId: Int, completion: @escaping (Result<ReviewTaskModels.GoalResponse, any Error>) -> Void)
}

final class ReviewTaskWorker: ReviewTaskWorkerProtocol {
    private let keychainService = KeychainService()
    private let baseUrlText: String = Server.url
    
    func loadGoal(with goalId: Int, completion: @escaping (Result<ReviewTaskModels.GoalResponse, any Error>) -> Void) {
        let urlText = baseUrlText + "/api/goal/\(goalId)"
        
        guard let url = URL(string: urlText) else {
            completion(.failure(ReviewTaskModels.ReviewTaskError.incorrectURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
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
                completion(.failure(ReviewTaskModels.ReviewTaskError.noData))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")
                if jsonString == "null" {
                    print("Empty profile")
                    completion(.failure(ReviewTaskModels.ReviewTaskError.noData))
                    return
                }
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let goal = try decoder.decode(ReviewTaskModels.GoalResponse.self, from: data)
                print("Got goal: \(goal)")
                completion(.success(goal))
            } catch {
                print("Error while decoding data: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
