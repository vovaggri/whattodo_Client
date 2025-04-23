import Foundation

protocol MainWorkerProtocol {
    func getUser(completion: @escaping (Result<MainModels.Fetch.UserResponse, Error>) -> Void)
    func getGoals(completion: @escaping (Result<[Goal], Error>) -> Void)
}

final class MainWorker: MainWorkerProtocol {
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
    
    func getGoals(completion: @escaping (Result<[Goal], Error>) -> Void) {
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
}
