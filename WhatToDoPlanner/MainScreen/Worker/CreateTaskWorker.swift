import Foundation

protocol CreateTaskWorkerProtocol {
    func createTask(with requestData: CreateTaskModels.CreateTaskRequest, goalId gId: Int, completion: @escaping (Result<Task, Error>) -> Void)
}

final class CreateTaskWorker: CreateTaskWorkerProtocol {
    private let keychainServer = KeychainService()
    
    func createTask(with requestData: CreateTaskModels.CreateTaskRequest, goalId gId: Int, completion: @escaping (Result<Task, Error>) -> Void) {
        let urlText: String = "http://localhost:8000/api/goal/\(gId)/items/"
        
        guard let url = URL(string: urlText) else {
            completion(.failure(CreateTaskModels.CreateTaskError.incorrectURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Указываем, что тело запроса в формате JSON
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let tokenData = keychainServer.getData(forKey: "userToken"), let token = String(data: tokenData, encoding: .utf8) {
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
                let response = try decoder.decode(CreateTaskModels.CreateTaskResponse.self, from: data)
                let newId = response.id
                let createdTask = Task(
                    id: newId,
                    title: requestData.title,
                    description: requestData.description,
                    colour: requestData.colour,
                    endDate: requestData.endDate,
                    done: requestData.done,
                    startTime: requestData.startTime,
                    endTime: requestData.endTime,
                    goalId: gId
                )
                print("Created success")
                completion(.success(createdTask))
            } catch {
                print(error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    
}

