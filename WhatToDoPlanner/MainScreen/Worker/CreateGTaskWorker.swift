import Foundation

protocol CreateGTaskWorkerProtocol {
    func createTask(with requestData: CreateGTask.Fetch.Request, goalId gId: Int, completion: @escaping (Result<Task, Error>) -> Void)
}

final class CreateGTaskWorker: CreateGTaskWorkerProtocol {
    private let keychainService = KeychainService()
    
    func createTask(with requestData: CreateGTask.Fetch.Request, goalId gId: Int, completion: @escaping (Result<Task, any Error>) -> Void) {
        let urlText: String = "http://localhost:8000/api/goal/\(gId)/items/"
        
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
                let response = try decoder.decode(CreateGTask.Fetch.Response.self, from: data)
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
                    done: false,
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
