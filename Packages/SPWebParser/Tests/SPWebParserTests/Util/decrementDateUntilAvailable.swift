import XCTest
@testable import SPError

func decrementDateUntilAvailable(maxCount: Int = 100, block: (Date) async throws -> Void) async rethrows {
    var date: Date = .init()
    var count: Int = 1
    
    while true {
        do {
            try await block(date)
            break
        } catch SPError.noAvailableNewsForSpecifiedDate {
            count += 1
            
            guard count <= 100 else {
                XCTFail()
                break
            }
            
            date = date.before(day: 1)!
        } catch {
            throw error
        }
    }
}
