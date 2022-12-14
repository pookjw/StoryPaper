import Foundation

public protocol SPNewsResultPage: Sendable, Hashable {
    var currentPage: Int { get }
    var hasMorePage: Bool { get }
}

public protocol SPNewsResult: Sendable, Hashable {
    associatedtype NewsResultPage: SPNewsResultPage
    associatedtype NewsSection: SPNewsSection
    
    var page: NewsResultPage? { get }
    var sections: [NewsSection] { get }
}
