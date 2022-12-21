import XCTest
@testable import SPWebParser
@testable import SPError

func incrementPageUntilAvailable(maxPage: Int = 100, block: (Int) async throws -> any SPNewsResult) async rethrows {
    var page: Int = 1
    
    while true {
        let newsResult: any SPNewsResult = try await block(page)
        
        guard newsResult.hasMorePage else {
            return
        }
        
        page += 1
        
        guard page < 100 else {
            XCTFail("Too large page.")
            return
        }
    }
}
