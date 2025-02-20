import Foundation

protocol WelcomeWorkerProtocol {
    func signIn(user: WelcomeModels.User, completion: @escaping (Result<Void, Error>) -> Void)
}

final class WelcomeWorker: WelcomeWorkerProtocol {
    private let baseURL: String = "http://localhost:8000"
    
    func signIn(user: WelcomeModels.User, completion: @escaping (Result<Void, any Error>) -> Void) {
        print("SignUp was called")
        guard let url = URL(string: "\(baseURL)/auth/sign-in") else {
            completion(.failure(NSError(domain: "SignInError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": user.email,
            "password": user.password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Ошибка сериализации JSON: \(error)")
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("Completion block reached")
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response body: \(responseString)")
                }
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let response = response as? HTTPURLResponse {
                    print(response.statusCode)
                    print(response.allHeaderFields)
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        if(responseString == "{\"message\":\"sql: no rows in result set\"}") {
                            completion(.failure(NSError(domain: "SignInError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Incorrect email or password"])))
                        } else {
                            completion(.failure(NSError(domain: "SignInError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Sign In failed"])))
                        }
                    } else {
                        completion(.failure(NSError(domain: "SignInError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Sign In failed"])))
                    }
                    return
                }
                
                completion(.success(()))
            }
            
        }
        
        task.resume()
    }
}
