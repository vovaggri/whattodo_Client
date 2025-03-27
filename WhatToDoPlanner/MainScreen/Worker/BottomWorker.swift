import Foundation

protocol BottomWorkerProtocol {
    func getTasks() -> [Task]
}

final class BottomWorker: BottomWorkerProtocol {
    private let keychainService = KeychainService()
    private let urlText: String = "http://localhost:8000/api/item/"
    private var tasks: [Task] = []
    
    func getTasks() -> [Task] {
        if let tokenData = keychainService.getData(forKey: "userToken"), let token = String(data: tokenData, encoding: .utf8) {
            print("token: \(token)")
            
            guard let url = URL(string: urlText) else {
                print("Incorrect URL")
                return tasks
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error of getting data: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data on answer")
                    return
                }
            }
            
        } else {
            print("Cannot take keychain")
        }
        return tasks
    }
}
