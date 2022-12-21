import Foundation

struct MbcNewsItem: SPNewsItem {
    let title: String
    let description: String?
    let thumbnailImageURL: URL?
    let documentURL: URL
    let date: Date?
    let author: String?
}
