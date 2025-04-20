import EventKit
import UIKit

protocol CalendarManaging {
    func create(eventModel: CalendarEventModel) -> Bool
}

struct CalendarEventModel: Encodable, Decodable {
    var title: String
    var description: String
    var endDate: Date
    var startTime: Date
    var endTime: Date
}

final class CalendarManager: CalendarManaging {
    private let eventStore : EKEventStore = EKEventStore()
    func create(eventModel: CalendarEventModel) -> Bool {
        var result: Bool = false
        let group = DispatchGroup()
        group.enter()
        create(eventModel: eventModel) { isCreated in
            result = isCreated
            group.leave()
        }
        group.wait()
        return result
    }
    func create(eventModel: CalendarEventModel, completion: ((Bool) -> Void)?) {
        let createEvent: EKEventStoreRequestAccessCompletionHandler = { [weak self] (granted, error) in
            guard granted, error == nil, let self else {
                completion?(false)
                return
            }
            let event: EKEvent = EKEvent(eventStore: self.eventStore)
            event.title = eventModel.title
            event.notes = eventModel.description
            event.calendar = self.eventStore.defaultCalendarForNewEvents
            
            let calendar = Calendar.current
            
            // Date (year/month/day)
            let dateComp = calendar.dateComponents([.year, .month, .day], from: eventModel.endDate)
            
            // Start and End time
            let startTimeComp = calendar.dateComponents([.hour, .minute, .second], from: eventModel.startTime)
            let endTimeComp = calendar.dateComponents([.hour, .minute, .second], from: eventModel.endTime)
            
            // Check for all-day
            if startTimeComp == endTimeComp {
                let localCal = Calendar.current

                let ymd = localCal.dateComponents([.year, .month, .day], from: eventModel.endDate)

                guard let startOfDay = localCal.date(from: ymd),
                    let endOfDay = localCal.date(byAdding: .day, value: 1, to: startOfDay)
                else {
                    completion?(false)
                    return
                }

                event.startDate = startOfDay
                event.endDate = endOfDay
                event.isAllDay = true
            } else {
                // Event with fixed time
                var startComp = dateComp
                startComp.hour   = startTimeComp.hour
                startComp.minute = startTimeComp.minute
                startComp.second = startTimeComp.second

                var endComp = dateComp
                endComp.hour   = endTimeComp.hour
                endComp.minute = endTimeComp.minute
                endComp.second = endTimeComp.second
                
                guard
                    let composedStart = calendar.date(from: startComp),
                    let composedEnd = calendar.date(from: endComp)
                else {
                    completion?(false)
                    return
                }
                
                event.isAllDay = false
                event.startDate = composedStart
                event.endDate = composedEnd
            }
            
            do {
                try self.eventStore.save(event, span: .thisEvent)
            } catch let error as NSError {
                print("failed to save event with error : \(error)")
                completion?(false)
            }
            completion?(true)
        }
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: createEvent)
        } else {
            eventStore.requestAccess(to: .event, completion: createEvent)
        }
    }
}

