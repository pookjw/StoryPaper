import XCTest
import UniformTypeIdentifiers
@testable import SPWebParser

final class MbcNewsIndexDataTests: XCTestCase {
    func test_decodingNetworkSample() throws {
        let fileURL: URL = Bundle
            .module
            .url(
                forResource: "mbc_news_network_article_data_sample",
                withExtension: UTType.json.preferredFilenameExtension
            )!
        
        try testJSONDecoding(fileURL: fileURL)
    }
    
    func test_decodingNewsinsightSample() throws {
        let fileURL: URL = Bundle
            .module
            .url(
                forResource: "mbc_newsinsight_article_data_sample",
                withExtension: UTType.json.preferredFilenameExtension
            )!
        
        try testJSONDecoding(fileURL: fileURL)
    }
    
    private func testJSONDecoding(fileURL: URL) throws {
        let data: Data = try .init(contentsOf: fileURL)
        let decoder: JSONDecoder = .init()
        decoder.allowsJSON5 = true
        let indexData: MbcNewsIndexData = try decoder.decode(MbcNewsIndexData.self, from: data)
        
        XCTAssertFalse(indexData.data.isEmpty)
        indexData
            .data
            .forEach { data in
                XCTAssertFalse(data.list.isEmpty)
                
                data
                    .list
                    .forEach { item in
                        XCTAssertNotNil(item.section)
                        XCTAssertNotNil(item.imageURL)
                        XCTAssertNotNil(item.title)
                        XCTAssertNotNil(item.linkURL)
                        XCTAssertNotNil(item.author)
                        XCTAssertNotNil(item.startDate)
                    }
            }
    }
}
