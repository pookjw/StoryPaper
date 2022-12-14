import Foundation

public protocol SPNewsCatetory: Sendable, Hashable, CaseIterable {
    var text: String { get }
}
