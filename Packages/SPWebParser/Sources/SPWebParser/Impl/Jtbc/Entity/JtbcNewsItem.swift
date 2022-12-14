import Foundation

public struct JtbcNewsItem: SPNewsItem {
    public let title: String
    public let description: String?
    public let thumbnailImageURL: URL?
    public let documentURL: URL
    public let date: Date?
}
