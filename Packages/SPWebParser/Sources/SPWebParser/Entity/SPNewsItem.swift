import Foundation

public protocol SPNewsItem: Sendable, Hashable {
    var title: String { get }
    var description: String? { get }
    var thumbnailImageURL: URL? { get }
    var documentURL: URL { get }
    var date: Date? { get }
    var author: String? { get }
}
