import Foundation

enum TasksTest {
    static private let calendar = Calendar.current
    static private let now = Date()
    
    static private var firstStartComponents: DateComponents = {
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 11
        components.minute = 0
        return components
    }()
    
    static private var firstEndComponents: DateComponents = {
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 14
        components.minute = 0
        return components
    }()
    
    private static var firstStartTime = calendar.date(from: firstStartComponents)
    private static var firstEndTime = calendar.date(from: firstEndComponents)
    
    static private var secondStartComponents: DateComponents = {
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 15
        components.minute = 0
        return components
    }()
    
    static private var secondEndComponents: DateComponents = {
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 16
        components.minute = 0
        return components
    }()
    
    private static var secondStartTime = calendar.date(from: secondStartComponents)
    private static var secondEndTime = calendar.date(from: secondEndComponents)
    
    static var tasks: [Task] = [
        Task(id: 1,
             title: "Finish iOS project",
             description: "Send the project to form",
             date: Date(),
             done: false,
             startTime: firstStartTime,
             endTime: firstEndTime),
        
        Task(id: 2,
             title: "Buy groceries",
             description: "Milk, eggs, bread",
             date: Date(),
             done: false),
        
        Task(id: 3,
             title: "Walk the dog",
             description: nil,
             date: Date(),
             done: false),
        
        Task(id: 4,
             title: "Read Swift documentation",
             description: nil,
             date: Date(),
             done: false),
        
        Task(id: 5,
             title: "Reading",
             description: nil,
             date: Date(),
             done: false,
             startTime: secondStartTime,
             endTime: secondEndTime)
    ]
}

