import Foundation

protocol CalendarInteractorProtocol {
    func fetchCalendar()
    func didSelectDay(_ date: Date)
}

final class CalendarInteractor: CalendarInteractorProtocol {
    private var presenter: CalendarPresenterProtocol?
    private var worker: CalendarWorkerProtocol?
    
    private var weeks: [[CalendarModels.CalendarDay]] = []
    private var title: String = ""
    
    init(presenter: CalendarPresenterProtocol?, worker: CalendarWorkerProtocol?) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func fetchCalendar() {
        let currentDate = Date()
        
        let result = getWeeks(for: currentDate)
        self.title = result.title
        self.weeks = result.weeks
        
        presenter?.presentCalendar(title: title, weeks: weeks)
    }
    
    func didSelectDay(_ date: Date) {
        var newWeeks: [[CalendarModels.CalendarDay]] = []
        
        for week in weeks {
            let newWeek = week.map { day -> CalendarModels.CalendarDay in
                CalendarModels.CalendarDay(
                    date: day.date,
                    dayNumber: day.dayNumber,
                    isSelected: isSameDay(day.date, date),
                    isToday: day.isToday
                )
            }
            newWeeks.append(newWeek)
        }
        
        self.weeks = newWeeks
        presenter?.presentCalendar(title: title, weeks: weeks)
    }
    
    private func getWeeks(for date: Date) -> (title: String, weeks: [[CalendarModels.CalendarDay]]) {
        var calendar = Calendar(identifier: .gregorian)
        // Если хотим, чтобы неделя начиналась с понедельника:
        calendar.firstWeekday = 2  // (1 = воскресенье, 2 = понедельник)
                
        // 1) Находим 1-е число месяца
        guard let startOfMonth = calendar.date( from: calendar.dateComponents([.year, .month], from: date)) else {
            return ("", [])
        }
                
        // 2) Находим конец месяца (последний день)
        var monthComponents = DateComponents()
        monthComponents.month = 1
        guard let endOfMonth = calendar.date(byAdding: monthComponents, to: startOfMonth)?.addingTimeInterval(-1) else {
            return ("", [])
        }
                
        // 3) Определяем начало недели, в которую входит startOfMonth
        guard let startOfWeekInterval = calendar.dateInterval(of: .weekOfYear, for: startOfMonth) else {
            return ("", [])
        }
        let startOfFirstWeek = startOfWeekInterval.start
            
        // 4) Определяем конец недели, в которую входит endOfMonth
        guard let endOfWeekInterval = calendar.dateInterval(of: .weekOfYear, for: endOfMonth) else {
            return ("", [])
        }
        // endOfWeekInterval.end — это уже начало следующего дня после конца недели,
        // поэтому вычитаем 1 секунду, чтобы получить «последнюю» дату
        let endOfLastWeek = endOfWeekInterval.end.addingTimeInterval(-1)
                
        // 5) Собираем все даты день за днём от startOfFirstWeek до endOfLastWeek
        var daysAll: [CalendarModels.CalendarDay] = []
        var currentDate = startOfFirstWeek
        let today = Date()
                
        while currentDate <= endOfLastWeek {
            let dayNumber = calendar.component(.day, from: currentDate)
            let isToday = calendar.isDateInToday(currentDate)
                    
            let dayModel = CalendarModels.CalendarDay(
                date: currentDate,
                dayNumber: "\(dayNumber)",
                isSelected: false,
                isToday: isToday
            )
            daysAll.append(dayModel)
                    
            // Переходим к следующему дню
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDay
        }
                
        // 6) Разбиваем массив daysAll на недели по 7 дней
        var weeks: [[CalendarModels.CalendarDay]] = []
        for i in stride(from: 0, to: daysAll.count, by: 7) {
            let chunk = Array(daysAll[i..<min(i+7, daysAll.count)])
            weeks.append(chunk)
        }
                
        // 7) Для «title» используем месяц/год выбранной даты (например, "March 2025")
        let title = startOfMonth.getMonthYearString()
                
        return (title, weeks)
    }
    
    private func isSameDay(_ lhs: Date, _ rhs: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(lhs, inSameDayAs: rhs)
    }
}

