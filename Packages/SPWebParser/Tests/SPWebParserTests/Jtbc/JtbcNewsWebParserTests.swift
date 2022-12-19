import XCTest
@testable import SPWebParser
@testable import SPLogger

final class JtbcNewsWebParserTests: XCTestCase {
    private let jtbcWebParser: JtbcNewsWebParser = .init()
    
    func test_resultForhome() async throws {
        let result: any SPNewsResult = try await jtbcWebParser.newsResultForHome(requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForBreakingNews() async throws {
        try await decrementDateUntilAvailable { date in
            try await incrementPageUntilAvailable { page in
                let result: any SPNewsResult = try await jtbcWebParser.newsResult(from: JtbcNewsCategory.breakingNews, requestValues: [.page(page), .day(date)])
                log.notice(result)
                result.assertIfNeeded()
                return result
            }
        }
    }
    
    func test_resultForPolitics() async throws {
        let result: any SPNewsResult = try await jtbcWebParser.newsResult(from: JtbcNewsCategory.politics, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForEconomy() async throws {
        let result: any SPNewsResult = try await jtbcWebParser.newsResult(from: JtbcNewsCategory.economy, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForSociety() async throws {
        let result: any SPNewsResult = try await jtbcWebParser.newsResult(from: JtbcNewsCategory.society, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForInternational() async throws {
        let result: any SPNewsResult = try await jtbcWebParser.newsResult(from: JtbcNewsCategory.international, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForCulture() async throws {
        let result: any SPNewsResult = try await jtbcWebParser.newsResult(from: JtbcNewsCategory.culture, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForEntertainments() async throws {
        let result: any SPNewsResult = try await jtbcWebParser.newsResult(from: JtbcNewsCategory.entertainments, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForSports() async throws {
        let result: any SPNewsResult = try await jtbcWebParser.newsResult(from: JtbcNewsCategory.sports, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForWeather() async throws {
        let result: any SPNewsResult = try await jtbcWebParser.newsResult(from: JtbcNewsCategory.weather, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForJtbcNewsRoom() async throws {
        try await decrementDateUntilAvailable { date in
            let result: any SPNewsResult = try await jtbcWebParser.newsResult(from: JtbcNewsCategory.jtbcNewsroom, requestValues: [.day(date)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_resultForSangamdongClass() async throws {
        try await decrementDateUntilAvailable { date in
            let result: any SPNewsResult = try await jtbcWebParser.newsResult(from: JtbcNewsCategory.sangamdongClass, requestValues: [.day(date)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_resultForPoliticalDepartmentMeeting() async throws {
        try await decrementDateUntilAvailable { date in
            let result: any SPNewsResult = try await jtbcWebParser.newsResult(from: JtbcNewsCategory.politicalDepartmentMeeting, requestValues: [.day(date)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
}
