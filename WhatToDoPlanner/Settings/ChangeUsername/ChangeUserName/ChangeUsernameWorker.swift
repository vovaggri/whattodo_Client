import Foundation

protocol ChangeUsernameWorkerProtocol {
    func changeFullName(requestData: ChangeUsername.UpdateModelName, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ChangeUsernameWorker: ChangeUsernameWorkerProtocol {
    private let keychainService = KeychainService()
    private var baseUrl: String = Server.url
    
    func changeFullName(requestData: ChangeUsername.UpdateModelName, completion: @escaping (Result<Void, any Error>) -> Void) {
        let urlText: String = baseUrl + "/api/user"
        
        guard let url = URL(string: urlText) else {
            completion(.failure(NSError(domain: "ChangeUsername", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
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
                let response = try decoder.decode(ChangeUsername.updateResponse.self, from: data)
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
