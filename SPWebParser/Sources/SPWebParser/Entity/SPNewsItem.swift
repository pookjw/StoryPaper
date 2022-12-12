import Foundation

public protocol SPNewsItem: Sendable, Hashable {
    var title: String { get }
    var description: String? { get }
    var imageURL: URL? { get }
    var documentURL: String { get }
    var date: Date? { get }
}
