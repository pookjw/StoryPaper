import XCTest
@testable import SPWebParser
@testable import SPLogger

final class JtbcNewsWebParserTests: XCTestCase {
    private let jtbcWebParser: JtbcNewsWebParser = .init()
    
    func test_resultForhome() async throws {
        let result: JtbcNewsResult = try await jtbcWebParser.newsResultForHome()
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForBreakingNews() async throws {
        try await decrementDateUntilAvailable { date in
            try await incrementPageUntilAvailable { page in
                let result: JtbcNewsResult = try await jtbcWebParser.newsResult(from: .breakingNews((page: page, day: date)))
                log.notice(result)
                result.assertIfNeeded()
                return result
            }
        }
    }
    
    func test_resultForPolitics() async throws {
        let result: JtbcNewsResult = try await jtbcWebParser.newsResult(from: .politics)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForEconomy() async throws {
        let result: JtbcNewsResult = try await jtbcWebParser.newsResult(from: .economy)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForSociety() async throws {
        let result: JtbcNewsResult = try await jtbcWebParser.newsResult(from: .society)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForInternational() async throws {
        let result: JtbcNewsResult = try await jtbcWebParser.newsResult(from: .international)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForCulture() async throws {
        let result: JtbcNewsResult = try await jtbcWebParser.newsResult(from: .culture)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForEntertainments() async throws {
        let result: JtbcNewsResult = try await jtbcWebParser.newsResult(from: .entertainments)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForSports() async throws {
        let result: JtbcNewsResult = try await jtbcWebParser.newsResult(from: .sports)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForWeather() async throws {
        let result: JtbcNewsResult = try await jtbcWebParser.newsResult(from: .weather)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_resultForJtbcNewsRoom() async throws {
        try await decrementDateUntilAvailable { date in
            let result: JtbcNewsResult = try await jtbcWebParser.newsResult(from: .jtbcNewsroom(date))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_resultForSangamdongClass() async throws {
        try await decrementDateUntilAvailable { date in
            let result: JtbcNewsResult = try await jtbcWebParser.newsResult(from: .sangamdongClass(date))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_resultForPoliticalDepartmentMeeting() async throws {
        try await decrementDateUntilAvailable { date in
            let result: JtbcNewsResult = try await jtbcWebParser.newsResult(from: .politicalDepartmentMeeting(date))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
}
