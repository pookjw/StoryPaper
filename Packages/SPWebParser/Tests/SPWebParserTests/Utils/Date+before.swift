import Foundation

extension Date {
    func before(day: Int) -> Date? {
        let calendar: Calendar = .init(identifier: .gregorian)
        var components: DateComponents = .init(calendar: calendar)
        components.day = -day
        return calendar.date(byAdding: components, to: self)
    }
    
    func before(year: Int) -> Date? {
        let calendar: Calendar = .init(identifier: .gregorian)
        var components: DateComponents = .init(calendar: calendar)
        components.year = -year
        return calendar.date(byAdding: components, to: self)
    }
}
