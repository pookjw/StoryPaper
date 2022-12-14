import Foundation

public protocol SPNewsSection: Sendable, Hashable {
    associatedtype NewsItem: SPNewsItem
    
    var title: String? { get }
    var badgeText: String? { get }
    var newsItems: [NewsItem] { get }
}
