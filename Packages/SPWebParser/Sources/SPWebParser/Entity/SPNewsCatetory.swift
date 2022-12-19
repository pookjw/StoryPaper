import Foundation

public enum SPNewsCategoryRequestValue: Sendable, Hashable {
    case page(Int!)
    case day(Date!)
    case year(Int!)
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .page:
            hasher.combine(Int.zero)
        case .day:
            hasher.combine(1)
        case .year:
            hasher.combine(2)
        }
    }
    
    static func page(from requestFields: Set<Self>) -> Int! {
        requestFields
            .compactMap { requestField -> Int? in
                guard case let .page(page) = requestField else {
                    return nil
                }
                return page
            }
            .first
    }
    
    static func day(from requestFields: Set<Self>) -> Date! {
        requestFields
            .compactMap { requestField -> Date? in
                guard case let .day(day) = requestField else {
                    return nil
                }
                return day
            }
            .first
    }
    
    static func year(from requestFields: Set<Self>) -> Int! {
        requestFields
            .compactMap { requestField -> Int? in
                guard case let .year(year) = requestField else {
                    return nil
                }
                return year
            }
            .first
    }
}

public protocol SPNewsCatetory: Sendable, CaseIterable, Hashable {
    var text: String { get }
    var requestValues: [SPNewsCategoryRequestValue] { get }
}

extension SPNewsCatetory {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(reflecting: self))
    }
}
