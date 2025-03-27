//
//  SignUpService.swift
//  WhatToDoPlanner
//
//  Created by Vladimir Grigoryev on 31.01.2025.
//

import Foundation

protocol SignUpServiceProtocol {
    func signUp(user: SignUpModels.User, completion: @escaping (Result<Void, Error>) -> Void)
}

final class SignUpService: SignUpServiceProtocol {
    private let baseURL = "http://localhost:8000"
    
    func signUp(user: SignUpModels.User, completion: @escaping (Result<Void, any Error>) -> Void) {
        print("SignUp was called")
        guard let url = URL(string: "\(baseURL)/auth/sign-up") else {
            completion(.failure(NSError(domain: "SignUpError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "first_name": user.firstName,
            "second_name": user.lastName,
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
                        if(responseString == "{\"message\":\"pq: duplicate key value violates unique constraint \\\"users_email_key\\\"\"}") {
                            completion(.failure(NSError(domain: "SignUpError", code: 1, userInfo: [NSLocalizedDescriptionKey: "This email was already registered"])))
                        } else {
                            completion(.failure(NSError(domain: "SignUpError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Registration failed"])))
                        }
                    } else {
                        completion(.failure(NSError(domain: "SignUpError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Registration failed"])))
                    }
                    return
                }
                
                completion(.success(()))
            }
            
        }
        
        task.resume()
    }
    
    
}
