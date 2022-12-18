import Foundation

public protocol SPNewsResult: Sendable, Hashable {
    associatedtype NewsSection: SPNewsSection
    
    var hasMorePage: Bool { get }
    var sections: [NewsSection] { get }
}
