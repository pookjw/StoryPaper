import Foundation

public struct MbcNewsResult: SPNewsResult {
    public typealias NewsSection = MbcNewsSection
    
    public let hasMorePage: Bool
    public let sections: [MbcNewsSection]
}
