import Foundation

public struct MbcNewsItem: SPNewsItem {
    public let title: String
    public let description: String?
    public let thumbnailImageURL: URL?
    public let documentURL: URL
    public let date: Date?
    public let author: String?
}
