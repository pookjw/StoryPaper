import XCTest
@testable import SPWebParser
@testable import SPError

func decrementYearUntilAvailable(maxCount: Int = 100, block: (Int) async throws -> Void) async rethrows {
    var date: Date = .init()
    var count: Int = 1
    
    while true {
        do {
            let year: Int = try! date.year
            try await block(year)
            break
        } catch SPError.noAvailableNewsForSpecifiedDate {
            count += 1
            
            guard count <= 100 else {
                XCTFail()
                break
            }
            
            date = date.before(year: 1)!
        } catch {
            throw error
        }
    }
}
