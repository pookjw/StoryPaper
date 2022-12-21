import XCTest
@testable import SPWebParser

extension SPNewsResult {
    func assertIfNeeded() {
        XCTAssertFalse(sections.isEmpty)
        
        sections
            .forEach { section in
                XCTAssertFalse(section.newsItems.isEmpty)
        }
    }
}
