import Foundation

public protocol SPNewsCatetory: Sendable {
    var text: String { get }
    var requestDateComponent: SPNewsRequestDateComponent? { get }
}
