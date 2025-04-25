import Foundation

/// Stub worker to send your “create goal” request.
final class ChangeGoalWorker: ChangeGoalWorkerProtocol {
    private let keychainService = KeychainService()
    
    func updateGoal(id: Int, with requestData: CreateGoal.CreateGoalRequest, completion: @escaping (Result<Void, any Error>) -> Void) {
        let urlText: String = Server.url + "/api/goal/\(id)"
        
        guard let url = URL(string: urlText) else {
            completion(.failure(CreateGoal.CreateGoalError.incorrectURL))
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
            
            let httpResponse = response as? HTTPURLResponse
            print("Status updated goal code: \(httpResponse?.statusCode ?? 0)")
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(CreateGoal.CreateGoalError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let response = try decoder.decode(ChangeGoalModels.ChangeResponse.self, from: data)
                print("Status: \(response.status)")
                print("Created success")
                completion(.success(()))
            } catch {
                print(error)
                completion(.failure(error))
            }
        }.resume()
    }
}
