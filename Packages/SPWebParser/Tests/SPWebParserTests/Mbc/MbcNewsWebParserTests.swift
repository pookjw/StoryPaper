import XCTest
@testable import SPWebParser
@testable import SPLogger

final class MbcNewsWebParserTests: XCTestCase {
    private let mbcNewsWebParser: MbcNewsWebParser = .init()
    
    func test_resultForHome() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResultForHome(requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForNewsDesk() async throws {
        try await decrementDateUntilAvailable { date in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.newsDesk, requestValues: [.day(date)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForNwtoday() async throws {
        try await decrementDateUntilAvailable { date in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.nwtoday, requestValues: [.day(date)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForNw1400() async throws {
        try await decrementDateUntilAvailable { date in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.nw1400, requestValues: [.day(date)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForNewsflash() async throws {
        try await decrementYearUntilAvailable { year in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.newsflash, requestValues: [.year(year)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForNw930() async throws {
        try await decrementDateUntilAvailable { date in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.nw930, requestValues: [.day(date)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForNw1200() async throws {
        try await decrementDateUntilAvailable { date in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.nw1200, requestValues: [.day(date)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForNw1700() async throws {
        try await decrementDateUntilAvailable { date in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.nw1700, requestValues: [.day(date)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForStraight() async throws {
        try await decrementYearUntilAvailable { year in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.straight, requestValues: [.year(year)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForUnity() async throws {
        try await decrementYearUntilAvailable { year in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.unity, requestValues: [.year(year)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForPolitics() async throws {
        try await decrementDateUntilAvailable { date in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.politics, requestValues: [.day(date)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForSociety() async throws {
        try await decrementDateUntilAvailable { date in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.society, requestValues: [.day(date)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForWorld() async throws {
        try await decrementDateUntilAvailable { date in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.world, requestValues: [.day(date)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForEcono() async throws {
        try await decrementDateUntilAvailable { date in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.econo, requestValues: [.day(date)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForCulture() async throws {
        try await decrementDateUntilAvailable { date in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.culture, requestValues: [.day(date)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForNetwork() async throws {
        try await decrementYearUntilAvailable { year in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.network, requestValues: [.year(year)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForSports() async throws {
        try await decrementDateUntilAvailable { date in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.sports, requestValues: [.day(date)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForEnter() async throws {
        try await decrementDateUntilAvailable { date in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.enter, requestValues: [.day(date)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    
    func test_newsResultForGroupnews() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.groupnews, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForPoliticstime() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.politicstime, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForTodaythisnw() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.todaythisnw, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForStreeteco() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.streeteco, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForAhplus() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.ahplus, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForRoadman() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.roadman, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForNewsinsight() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.newsinsight, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForTurnedout() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.turnedout, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForWorldnow() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.worldnow, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForOtbt() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.otbt, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForDetecm() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.detecm, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForKindreporters() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.kindreporters, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForCereport() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.cereport, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForLmkeco() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.lmkeco, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForSeochom() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.seochom, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForVod365() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.vod365, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForIssue12() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.issue12, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForPyhotline() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.pyhotline, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultForMaxmlb() async throws {
        let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.maxmlb, requestValues: [])
        log.notice(result)
        result.assertIfNeeded()
    }
    
    func test_newsResultFor14f() async throws {
        try await decrementYearUntilAvailable { year in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory._14f, requestValues: [.year(year)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
    
    func test_newsResultForMbic() async throws {
        try await decrementYearUntilAvailable { year in
            let result: any SPNewsResult = try await mbcNewsWebParser.newsResult(from: MbcNewsCategory.mbic, requestValues: [.year(year)])
            log.notice(result)
            result.assertIfNeeded()
        }
    }
}
