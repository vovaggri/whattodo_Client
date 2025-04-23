import Foundation

protocol AIWorkerProtocol {
    func loadGoal(with goalId: Int, completion: @escaping (Result<GoalDetail.GoalResponse, any Error>) -> Void)
    func loadAIResponse(with goalId: Int, completion: @escaping (Result<String, Error>) -> Void)
}

final class AIWorker: AIWorkerProtocol {
    private let keychainService = KeychainService()
    private let baseUrlText: String = Server.url
    
    func loadGoal(with goalId: Int, completion: @escaping (Result<GoalDetail.GoalResponse, any Error>) -> Void) {
        let urlText = baseUrlText + "/api/goal/\(goalId)"
        
        guard let url = URL(string: urlText) else {
            completion(.failure(CreateGoal.CreateGoalError.incorrectURL))
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
                completion(.failure(CreateGoal.CreateGoalError.noData))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")
                if jsonString == "null" {
                    print("Empty profile")
                    completion(.failure(CreateGoal.CreateGoalError.noData))
                    return
                }
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let goal = try decoder.decode(GoalDetail.GoalResponse.self, from: data)
                print("Got goal: \(goal)")
                completion(.success(goal))
            } catch {
                print("Error while decoding data: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func loadAIResponse(with goalId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let urlText = baseUrlText + "/api/goal/\(goalId)/askAI"
        
        guard let url = URL(string: urlText) else {
            completion(.failure(AIModels.AIError.incorrectURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // JSON Request
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
                completion(.failure(AIModels.AIError.noData))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")
                if jsonString == "null" {
                    print("Empty profile")
                    completion(.failure(AIModels.AIError.noData))
                    return
                }
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let answerBody = try decoder.decode(AIModels.AIResponse.self, from: data)
                print("Got answer: \(answerBody)")
                let answer = answerBody.advice
                completion(.success(answer))
            } catch {
                print("Error while decoding data: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
