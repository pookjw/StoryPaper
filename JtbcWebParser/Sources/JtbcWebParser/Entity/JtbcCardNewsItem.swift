import Foundation

public struct JtbcCardNewsItem: Sendable, Hashable {
    public let title: String
    public let thumbnailImageURL: URL
    public let date: Date
    public let imageURLs: [URL]
}
