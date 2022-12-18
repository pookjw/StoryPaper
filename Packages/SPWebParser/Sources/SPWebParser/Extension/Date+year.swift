import Foundation
import SPError

extension Date {
    var year: Int {
        get throws {
            let calendar: Calendar = .init(identifier: .gregorian)
            let components: DateComponents = calendar.dateComponents([.year], from: self)
            
            guard let year: Int = components.year else {
                throw SPError.unexpectedNil
            }
            
            return year
        }
    }
}
