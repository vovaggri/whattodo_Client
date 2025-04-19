import Foundation

protocol GoalDetailWorkerProtocol {
    func loadGoal(with goalId: Int, completion: @escaping (Result<GoalDetail.GoalResponse, any Error>) -> Void)
    func getTasks(with goalId: Int, completion: @escaping (Result<[Task], Error>) -> Void)
    func removeTask(with taskId: Int, completion: @escaping (Result<Void, Error>) -> Void)
}

final class GoalDetailWorker: GoalDetailWorkerProtocol {
    private let keychainService = KeychainService()
    private let baseUrlText: String = "http://localhost:8000"
    
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
    
    func getTasks(with goalId: Int, completion: @escaping (Result<[Task], Error>) -> Void) {
        if let tokenData = keychainService.getData(forKey: "userToken"),
           let token = String(data: tokenData, encoding: .utf8) {
            print("token: \(token)")
            
            let urlText = baseUrlText + "/api/goal/\(goalId)/items/"
            guard let url = URL(string: urlText) else {
                print("Incorrect URL")
                completion(.failure(NSError(domain: "GoalDetail", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error of getting data: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    print("No data on answer")
                    completion(.success([]))
                    return
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON Response: \(jsonString)")
                    if jsonString == "null" {
                        print("Empty tasks")
                        completion(.success([]))
                        return
                    }
                }
                
                let decoder = JSONDecoder()
                // Если сервер возвращает даты в ISO8601 формате:
                decoder.dateDecodingStrategy = .iso8601
                
                do {
                    let tasks = try decoder.decode([Task].self, from: data)
                    print("Got tasks: \(tasks)")
                    completion(.success(tasks))
                } catch {
                    print("Error while decoding data: \(error)")
                    completion(.failure(error))
                }
            }.resume()
            
        } else {
            print("Cannot take keychain")
            completion(.failure(NSError(domain: "KeychainError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Account wasn't found"])))
        }
    }
    
    func removeTask(with taskId: Int, completion: @escaping (Result<Void, any Error>) -> Void) {
        if let tokenData = keychainService.getData(forKey: "userToken"),
           let token = String(data: tokenData, encoding: .utf8) {
            let urlText = baseUrlText + "/api/goal/0/items/\(taskId)"
            guard let url = URL(string: urlText) else {
                print("Incorrect URL")
                completion(.failure(NSError(domain: "GoalDetail", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error of getting data: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    print("No data on answer")
                    completion(.failure(NSError(domain: "GoalDetail", code: 3, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    print(response.statusCode)
                    print(response.allHeaderFields)
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NSError(domain: "GoalDetail", code: 4, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                    return
                }
                completion(.success(()))
            }.resume()
        } else {
            print("Cannot take keychain")
            completion(.failure(NSError(domain: "KeychainError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Account wasn't found"])))
        }
    }
}
