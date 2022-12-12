import Foundation
import SPWebParser

public actor JtbcWebParser: NSObject {
    public func cardNewsItems() async throws -> [JtbcCardNewsItem] {
        return []
    }
}

extension JtbcWebParser: SPWebParser {
    public typealias Item = JtbcNewsItem
    public typealias Category = JtbcNewsCategory
    
    public func newsItemsForHome() async throws -> [JtbcNewsItem] {
        return []
    }
    
    public func newsItems(for category: JtbcNewsCategory) async throws -> [JtbcNewsItem] {
        return []
    }
}

extension JtbcWebParser: XMLParserDelegate {
    
}
