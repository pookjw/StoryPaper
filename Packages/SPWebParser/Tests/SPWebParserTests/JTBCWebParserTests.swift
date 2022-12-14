import XCTest
@testable import SPWebParser

final class JTBCWebParserTests: XCTestCase {
    private let jtbcWebParser: JtbcWebParser = .init()
    
    func test_newsSectionsForHome() async throws {
        let result: JtbcNewsResult = try await jtbcWebParser.newsSectionsForHome(page: nil, date: nil)
        XCTAssertFalse(result.sections.isEmpty)
    }
    
    func test_newsSectionsForBreakingNews() async throws {
        var page: Int = 1
        let date: Date = .init()
        
        while true {
            let result: JtbcNewsResult = try await jtbcWebParser.newsSections(for: .breakingNews, page: page, date: date)
            
            XCTAssertFalse(result.sections.isEmpty)
            
            guard result.page?.hasMorePage == true else {
                break
            }
            
            page += 1
        }
    }
}
