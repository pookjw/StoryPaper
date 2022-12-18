import Foundation

public struct JtbcNewsResult: SPNewsResult {
    public typealias NewsSection = JtbcNewsSection
    
    public let hasMorePage: Bool
    public let sections: [JtbcNewsSection]
}
