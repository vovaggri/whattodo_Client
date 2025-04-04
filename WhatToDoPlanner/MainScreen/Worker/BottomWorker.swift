import Foundation

protocol BottomWorkerProtocol {
    func getTasks(completion: @escaping (Result<[Task], Error>) -> Void)
}

final class BottomWorker: BottomWorkerProtocol {
    private let keychainService = KeychainService()
    private let urlText: String = "http://localhost:8000/api/goal/0/items/"
    
    func getTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        if let tokenData = keychainService.getData(forKey: "userToken"),
           let token = String(data: tokenData, encoding: .utf8) {
            print("token: \(token)")
            
            guard let url = URL(string: urlText) else {
                print("Incorrect URL")
                completion(.failure(NSError(domain: "BottomError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
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
}
