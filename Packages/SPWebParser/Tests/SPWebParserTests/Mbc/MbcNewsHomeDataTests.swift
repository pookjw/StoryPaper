import XCTest
import UniformTypeIdentifiers
@testable import SPWebParser

final class MbcNewsHomeDataTests: XCTestCase {
    func test_decodingSample() throws {
        let fileURL: URL = Bundle
            .module
            .url(
                forResource: "mbc_main_topnews_headline_news_sample",
                withExtension: UTType.json.preferredFilenameExtension
            )!
        let data: Data = try .init(contentsOf: fileURL)
        let decoder: JSONDecoder = .init()
        decoder.allowsJSON5 = true
        let calData: MbcNewsHomeData = try decoder.decode(MbcNewsHomeData.self, from: data)
        XCTAssertFalse(calData.data.isEmpty)
    }
}
