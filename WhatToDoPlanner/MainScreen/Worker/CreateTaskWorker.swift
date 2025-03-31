import Foundation

protocol CreateTaskWorkerProtocol {
    func createTask(with requestData: CreateTaskModels.CreateTaskRequest, completion: @escaping (Result<Void, Error>) -> Void)
}

final class CreateTaskWorker: CreateTaskWorkerProtocol {
    private let keychainServer = KeychainService()
    private let urlText: String = "http://localhost:8000/api/goal/0/items/"
    
    func createTask(with requestData: CreateTaskModels.CreateTaskRequest, completion: @escaping (Result<Void, Error>) -> Void) {
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
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                print("Created success")
                completion(.success(()))
            } else {
                completion(.failure(CreateTaskModels.CreateTaskError.noData))
            }
        }.resume()
    }
    
    
}

