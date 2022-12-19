import Foundation

public enum SPNews: Sendable, Hashable, CaseIterable {
    case jtbc
    case mbc
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(reflecting: self))
    }
    
    public var webParser: any SPWebParser {
        switch self {
        case .jtbc:
            return JtbcNewsWebParser()
        case .mbc:
            return MbcNewsWebParser()
        }
    }
    
    public var categories: [any SPNewsCatetory] {
        switch self {
        case .jtbc:
            return JtbcNewsCategory.allCases
        case .mbc:
            return MbcNewsCategory.allCases
        }
    }
    
    public var text: String {
        let key: String
        
        switch self {
        case .jtbc:
            key = "JTBC"
        case .mbc:
            key = "MBC"
        }
        
        return NSLocalizedString(key, tableName: "SPNews", bundle: .module, comment: .init())
    }
}
