import XCTest
@testable import SPWebParser
@testable import SPLogger

final class MbcNewsWebParserTests: XCTestCase {
    private let mbcNewsWebParser: MbcNewsWebParser = .init()
    
    func test_resultForHome() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResultForHome()
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForNewsDesk() async throws {
        try await decrementDateUntilAvailable { date in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .newsDesk(day: date))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForNwtoday() async throws {
        try await decrementDateUntilAvailable { date in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .nwtoday(day: date))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForNw1400() async throws {
        try await decrementDateUntilAvailable { date in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .nw1400(day: date))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForNewsflash() async throws {
        try await decrementYearUntilAvailable { year in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .newsflash(year: year))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForNw930() async throws {
        try await decrementDateUntilAvailable { date in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .nw930(day: date))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForNw1200() async throws {
        try await decrementDateUntilAvailable { date in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .nw1200(day: date))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForNw1700() async throws {
        try await decrementDateUntilAvailable { date in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .nw1700(day: date))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForStraight() async throws {
        try await decrementYearUntilAvailable { year in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .straight(year: year))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForUnity() async throws {
        try await decrementYearUntilAvailable { year in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .unity(year: year))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForPolitics() async throws {
        try await decrementDateUntilAvailable { date in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .politics(day: date))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForSociety() async throws {
        try await decrementDateUntilAvailable { date in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .society(day: date))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForWorld() async throws {
        try await decrementDateUntilAvailable { date in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .world(day: date))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForEcono() async throws {
        try await decrementDateUntilAvailable { date in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .econo(day: date))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForCulture() async throws {
        try await decrementDateUntilAvailable { date in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .culture(day: date))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForNetwork() async throws {
        try await decrementYearUntilAvailable { year in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .network(year: year))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForSports() async throws {
        try await decrementDateUntilAvailable { date in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .sports(day: date))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForEnter() async throws {
        try await decrementDateUntilAvailable { date in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .enter(day: date))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    
    func test_newsResultForGroupnews() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .groupnews)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForPoliticstime() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .politicstime)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForTodaythisnw() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .todaythisnw)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForStreeteco() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .streeteco)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForAhplus() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .ahplus)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForRoadman() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .roadman)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForNewsinsight() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .newsinsight)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForTurnedout() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .turnedout)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForWorldnow() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .worldnow)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForOtbt() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .otbt)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForDetecm() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .detecm)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForKindreporters() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .kindreporters)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForCereport() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .cereport)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForLmkeco() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .lmkeco)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForSeochom() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .seochom)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForVod365() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .vod365)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForIssue12() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .issue12)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForPyhotline() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .pyhotline)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForMaxmlb() async throws {
        let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .maxmlb)
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultFor14f() async throws {
        try await decrementYearUntilAvailable { year in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: ._14f(year: year))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForMbic() async throws {
        try await decrementYearUntilAvailable { year in
            let result: MbcNewsResult = try await mbcNewsWebParser.newsResult(from: .mbic(year: year))
            log.notice(result)
            result.assertIfNeeded()
        }
    }
}
