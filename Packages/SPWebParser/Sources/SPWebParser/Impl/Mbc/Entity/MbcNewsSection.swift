import Foundation

public struct MbcNewsSection: SPNewsSection {
    public typealias NewsItem = MbcNewsItem
    
    public let title: String?
    public let badgeText: String?
    public let newsItems: [MbcNewsItem]
}
