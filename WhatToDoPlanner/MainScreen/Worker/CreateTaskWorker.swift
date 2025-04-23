import Foundation

protocol CreateTaskWorkerProtocol {
    func createTask(with requestData: CreateTaskModels.CreateTaskRequest, goalId gId: Int, completion: @escaping (Result<Task, Error>) -> Void)
    func getGoals(completion: @escaping (Result<[Goal], Error>) -> Void)
}

final class CreateTaskWorker: CreateTaskWorkerProtocol {
    private let keychainService = KeychainService()
    private let baseUrl: String = Server.url
    
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
    
    func createTask(with requestData: CreateTaskModels.CreateTaskRequest, goalId gId: Int, completion: @escaping (Result<Task, Error>) -> Void) {
        let urlText: String = baseUrl + "/api/goal/\(gId)/tasks/"
        
        guard let url = URL(string: urlText) else {
            completion(.failure(CreateTaskModels.CreateTaskError.incorrectURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Указываем, что тело запроса в формате JSON
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let tokenData = keychainService.getData(forKey: "userToken"), let token = String(data: tokenData, encoding: .utf8) {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let jsonData = try encoder.encode(requestData)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON: \(jsonString)")
            }
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(CreateTaskModels.CreateTaskError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let response = try decoder.decode(CreateTaskModels.CreateTaskResponse.self, from: data)
                let newId = response.id
                
                // Исправляем startTime и endTime, если год равен 0
                let fixedStartTime = self.fixYearIfNeeded(requestData.startTime)
                let fixedEndTime = self.fixYearIfNeeded(requestData.endTime)
                let createdTask = Task(
                    id: newId,
                    title: requestData.title,
                    description: requestData.description,
                    colour: requestData.colour,
                    endDate: requestData.endDate,
                    done: requestData.done,
                    startTime: fixedStartTime,
                    endTime: fixedEndTime,
                    goalId: gId
                )
                print("Created success")
                completion(.success(createdTask))
            } catch {
                print(error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Функция для корректировки даты: если год равен 0, заменяем его на 1970
    private func fixYearIfNeeded(_ date: Date?) -> Date? {
        guard let date = date else { return nil }
        var calendar = Calendar(identifier: .gregorian)
        // Если нужно работать с UTC, можно установить:
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        if let year = components.year, year == 0 {
            components.year = 1970
            return calendar.date(from: components)
        }
        return date
    }
}

