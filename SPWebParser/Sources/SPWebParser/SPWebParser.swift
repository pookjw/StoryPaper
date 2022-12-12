import Foundation

public protocol SPWebParser {
    associatedtype Item: SPNewsItem
    associatedtype Category: SPNewsCatetory
    
    func newsItemsForHome() async throws -> [Item]
    func newsItems(for category: Category) async throws -> [Item]
}
