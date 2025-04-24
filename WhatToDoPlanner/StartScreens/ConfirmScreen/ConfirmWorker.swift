import Foundation

protocol ConfirmWorkerProtocol {
    func sendCode(_ user: ConfirmScreen.UserConfirmRequest, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ConfirmWorker: ConfirmWorkerProtocol {
    private let urlText: String = Server.url + "/auth/verify-code"
    private let keychainService = KeychainService()
    
    func sendCode(_ user: ConfirmScreen.UserConfirmRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Send Code was called")
        guard let url = URL(string: urlText) else {
            completion(.failure(NSError(domain: "SendCodeError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": user.email,
            "code": user.code
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error serialization JSON: \(error)")
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("Completion block reached")
                
                if let data = data, let _ = String(data: data, encoding: .utf8) {
                    print("Response body")
                }
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    print(response.statusCode)
                    print(response.allHeaderFields)
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    if let data = data, let _ = String(data: data, encoding: .utf8) {
                        completion(.failure(NSError(domain: "SendCodeError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Send Code failed"])))
                    } else {
                        completion(.failure(NSError(domain: "SendCodeError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Send Code failed"])))
                    }
                    return
                }
                
                do {
                    guard let data = data else {
                        completion(.failure(NSError(domain: "SendCodeError", code: 3, userInfo: [NSLocalizedDescriptionKey: "No data in response"])))
                        return
                    }
                    
                    let tokenResponse = try JSONDecoder().decode(WelcomeModels.TokenResponse.self, from: data)
                    let token = tokenResponse.token
                    
                    guard let tokenData = token.data(using: .utf8) else {
                        completion(.failure(NSError(domain: "TokenError", code: 4, userInfo: [NSLocalizedDescriptionKey: "Unable to convert token to data"])))
                        return
                    }
                    
                    self.keychainService.setData(tokenData, forKey: "userToken")
                    completion(.success(()))

                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
