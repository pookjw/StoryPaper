import XCTest
import UniformTypeIdentifiers
@testable import SPWebParser

final class MbcNewsCalDataTests: XCTestCase {
    func test_decodingSample() throws {
        let fileURL: URL = Bundle
            .module
            .url(
                forResource: "mbc_replay_nwdesk_cal_data_sample",
                withExtension: UTType.json.preferredFilenameExtension
            )!
        let data: Data = try .init(contentsOf: fileURL)
        let decoder: JSONDecoder = .init()
        decoder.allowsJSON5 = true
        let calData: MbcNewsCalData = try decoder.decode(MbcNewsCalData.self, from: data)
        XCTAssertFalse(calData.dateList.isEmpty)
    }
}
