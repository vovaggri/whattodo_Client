import Foundation

protocol SettingsWorkerProtocol {
    func getUser(completion: @escaping (Result<MainModels.Fetch.UserResponse, Error>) -> Void)
}

final class SettingsWorker: SettingsWorkerProtocol {
    private let keychainService = KeychainService()
    private var baseUrl: String = Server.url
    
    func getUser(completion: @escaping (Result<MainModels.Fetch.UserResponse, Error>) -> Void) {
        if let tokenData = keychainService.getData(forKey: "userToken"),
           let token = String(data: tokenData, encoding: .utf8) {
            print("token: \(token)")
            
            let urlText = baseUrl + "/api/user"
            
            guard let url = URL(string: urlText) else {
                print("Incorrect url user")
                completion(.failure(MainModels.Fetch.MainError.incorrectURL))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    print("No data on answer")
                    completion(.failure(MainModels.Fetch.MainError.noData))
                    return
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON Response: \(jsonString)")
                    if jsonString == "null" {
                        print("Empty profile")
                        completion(.failure(MainModels.Fetch.MainError.noData))
                        return
                    }
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                do {
                    let user = try decoder.decode(MainModels.Fetch.UserResponse.self, from: data)
                    print("Got profile: \(user)")
                    completion(.success(user))
                } catch {
                    print("Error while decoding data: \(error)")
                    completion(.failure(error))
                }
            }.resume()
            
        } else {
            print("Cannot take keychain")
            completion(.failure(MainModels.Fetch.MainError.noKeychain))
        }
    }
}
