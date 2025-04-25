import Foundation

protocol ChangeTaskWorkerProtocol {
    func getGoals(completion: @escaping (Result<[Goal], Error>) -> Void)
    func updateTask(id: Int, with requestData: CreateTaskModels.CreateTaskRequest, goalId gId: Int, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ChangeTaskWorker: ChangeTaskWorkerProtocol {
    private let keychainService = KeychainService()
    private let baseUrl: String = Server.url
    
    func getGoals(completion: @escaping (Result<[Goal], any Error>) -> Void) {
        if let tokenData = keychainService.getData(forKey: "userToken"),
           let token = String(data: tokenData, encoding: .utf8) {
            let urlText = baseUrl + "/api/goal/"
            guard let url = URL(string: urlText) else {
                print("Incorrect url")
                completion(.failure(MainModels.Fetch.MainError.incorrectURL))
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
                    let goals = try decoder.decode([Goal].self, from: data)
                    print("Got tasks: \(goals)")
                    completion(.success(goals))
                } catch {
                    print("Error while decoding data: \(error)")
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    func updateTask(id: Int, with requestData: CreateTaskModels.CreateTaskRequest, goalId gId: Int, completion: @escaping (Result<Void, any Error>) -> Void) {
        let urlText: String = baseUrl + "/api/goal/\(gId)/tasks/\(id)"
        
        guard let url = URL(string: urlText) else {
            completion(.failure(CreateTaskModels.CreateTaskError.incorrectURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        // Указываем, что тело запроса в формате JSON
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let tokenData = keychainService.getData(forKey: "userToken"), let token = String(data: tokenData, encoding: .utf8) {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let jsonData = try encoder.encode(requestData)
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
                completion(.failure(error))
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(CreateTaskModels.CreateTaskError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let response = try decoder.decode(ChangeTaskModels.updateResponse.self, from: data)
                let status = response.status
                print(status)

                print("Updated success")
                completion(.success(()))
            } catch {
                print(error)
                completion(.failure(error))
            }
        }.resume()
    }
}
