import Foundation

protocol GoalReviewWorkerProtocol {
    func deleteGoal(with goal: Goal, completion: @escaping (Result<Void, Error>) -> Void)
    func getTasks(with goalId: Int, completion: @escaping (Result<[Task], Error>) -> Void)
    func updateTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void)
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
    
    func getTasks(with goalId: Int, completion: @escaping (Result<[Task], any Error>) -> Void) {
        if let tokenData = keychainService.getData(forKey: "userToken"),
           let token = String(data: tokenData, encoding: .utf8) {
            print("token: \(token)")
            
            let urlText = baseUrl + "/api/goal/\(goalId)/tasks/"
            guard let url = URL(string: urlText) else {
                print("Incorrect URL")
                completion(.failure(NSError(domain: "GoalReviewError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
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
    
    func updateTask(_ task: Task, completion: @escaping (Result<Void, any Error>) -> Void) {
        if let tokenData = keychainService.getData(forKey: "userToken"),
           let token = String(data: tokenData, encoding: .utf8) {
            let urlText = baseUrl + "/api/goal/\(task.goalId ?? 0)/tasks/\(task.id)"
            guard let url = URL(string: urlText) else {
                print("Incorrect URL")
                completion(.failure(NSError(domain: "BottomError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }
            
            let requestBody = BottomModels.updateTaskRequest(done: task.done)
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                let jsonData = try encoder.encode(requestBody)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("JSON: \(jsonString)")
                }
                request.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error of getting data: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    print(response.statusCode)
                    print(response.allHeaderFields)
                }
                
                guard let data = data, let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NSError(domain: "UpdateTaskError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Data not found"])))
                    return
                }
                
                print("updateTaskDone")
                completion(.success(()))
            }.resume()
        } else {
            print("Cannot take keychain")
            completion(.failure(NSError(domain: "KeychainError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Account wasn't found"])))
        }
    }
}
