import XCTest
@testable import SPWebParser

final class JTBCWebParserTests: XCTestCase {
    private let jtbcWebParser: JtbcWebParser = .init()
    
    func test_newsSectionsForHome() async throws {
        let newsSections: [JtbcNewsSection] = try await jtbcWebParser.newsSectionsForHome()
        XCTAssertFalse(newsSections.isEmpty)
    }
}
