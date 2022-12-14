import XCTest
@testable import SPWebParser
@testable import SPLogger

final class JTBCWebParserTests: XCTestCase {
    private let jtbcWebParser: JtbcWebParser = .init()
    
    func test_newsSectionsForHome_1() async throws {
        let result: JtbcNewsResult = try await jtbcWebParser.newsSectionsForHome(page: nil, date: nil)
        log.notice(result)
        XCTAssertFalse(result.sections.isEmpty)
    }
    
    func test_newsSectionsForHome_2() async throws {
        try await test_newsSections(for: .home)
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
            
            guard page < 100 else {
                XCTFail("Too large page.")
                return
            }
        }
    }
    
    func test_newsSectionsForPolitics() async throws {
        try await test_newsSections(for: .politics)
    }
    
    func test_newsSectionsForEconomy() async throws {
        try await test_newsSections(for: .economy)
    }
    
    func test_newsSectionsForSociety() async throws {
        try await test_newsSections(for: .society)
    }
    
    func test_newsSectionsForInternational() async throws {
        try await test_newsSections(for: .international)
    }
    
    func test_newsSectionsForCulture() async throws {
        try await test_newsSections(for: .culture)
    }
    
    func test_newsSectionsForEntertainments() async throws {
        try await test_newsSections(for: .entertainments)
    }
    
    func test_newsSectionsForSports() async throws {
        try await test_newsSections(for: .sports)
    }
    
    func test_newsSectionsForWeather() async throws {
        try await test_newsSections(for: .weather)
    }
    
    private func test_newsSections(for newsCategory: JtbcNewsCategory) async throws {
        let result: JtbcNewsResult = try await jtbcWebParser.newsSections(for: newsCategory, page: nil, date: nil)
        log.notice(result)
        XCTAssertFalse(result.sections.isEmpty)
    }
}
