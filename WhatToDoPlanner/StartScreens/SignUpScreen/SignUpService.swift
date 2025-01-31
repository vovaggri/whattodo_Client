//
//  SignUpService.swift
//  WhatToDoPlanner
//
//  Created by Vladimir Grigoryev on 31.01.2025.
//

import Foundation

protocol SignUpServiceProtocol {
    func signUp(firstName: String, lastName:String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class SignUpService: SignUpServiceProtocol {
    private let baseURL = "api"
    
    func signUp(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/register") else {
            completion(.failure(NSError(domain: "SignUpError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NSError(domain: "SignUpError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Registration failed"])))
                    return
                }
                
                completion(.success(()))
            }
            
        }
        
        task.resume()
    }
    
    
}
