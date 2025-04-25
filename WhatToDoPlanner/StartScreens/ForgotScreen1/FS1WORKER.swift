import Foundation

protocol ForgotScreenWorkerProtocol {
    func sendEmail(emailRequest: ForgotScreen.Fetch.Request, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ForgotScreenWorker: ForgotScreenWorkerProtocol {
    private let keychainService = KeychainService()
    private var baseUrl: String = Server.url
    
    func sendEmail(emailRequest: ForgotScreen.Fetch.Request, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/forgot-password/send-code") else {
            completion(.failure(NSError(domain: "ForgotPasswordError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": emailRequest.email
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
                    completion(.failure(NSError(domain: "ForgotPasswordError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Operation failed"])))
                    return
                }
                
                completion(.success(()))
            }
        }
        
        task.resume()
    }
}
