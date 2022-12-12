import Foundation
import SPWebParser

public struct JtbcNewsItem: SPNewsItem {
    public let title: String
    public let description: String?
    public let imageURL: URL?
    public let documentURL: String
    public let date: Date?
}
