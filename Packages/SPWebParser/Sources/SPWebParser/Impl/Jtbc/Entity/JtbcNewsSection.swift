import Foundation

public struct JtbcNewsSection: SPNewsSection {
    public typealias NewsItem = JtbcNewsItem
    
    public let title: String?
    public let badgeText: String?
    public let newsItems: [JtbcNewsItem]
}
