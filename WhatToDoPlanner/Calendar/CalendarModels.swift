import Foundation

enum CalendarModels {
    struct CalendarDay {
        let date: Date
        let dayNumber: String
        let isSelected: Bool
        let isToday: Bool
    }
    
    struct CalendarViewModel {
        let title: String
        let weeks: [[CalendarDay]]
    }
}
