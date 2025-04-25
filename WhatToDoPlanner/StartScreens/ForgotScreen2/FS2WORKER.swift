import Foundation

protocol ChangePasswordWorkerProtocol {
    func resetPassword(with requestModel: ChangePasswordModels.Request, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ChangePasswordWorker: ChangePasswordWorkerProtocol {
    private var baseUrl: String = Server.url
    
    func resetPassword(with requestModel: ChangePasswordModels.Request, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/forgot-password/reset-password") else {
            completion(.failure(NSError(domain: "ForgotPasswordError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": requestModel.email,
            "new_password": requestModel.newPassword
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
                    completion(.failure(NSError(domain: "ForgotPasswordError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Operation failed. Maybe new password isn't correct"])))
                    return
                }
                
                completion(.success(()))
            }
        }
        
        task.resume()
    }
}
