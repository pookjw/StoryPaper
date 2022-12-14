import Foundation

public struct JtbcNewsResult: SPNewsResult {
    public typealias NewsResultPage = Page
    public typealias NewsSection = JtbcNewsSection
    
    public struct Page: SPNewsResultPage {
        public let currentPage: Int
        public let hasMorePage: Bool
    }
    
    public let page: Page?
    public var sections: [JtbcNewsSection]
}
