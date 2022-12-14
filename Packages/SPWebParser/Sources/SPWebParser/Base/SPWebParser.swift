import Foundation

public protocol SPWebParser {
    associatedtype NewsResult: SPNewsResult
    associatedtype NewsCategory: SPNewsCatetory
    
    func newsSectionsForHome(page: Int?, date: Date?) async throws -> NewsResult
    func newsSections(for newsCategory: NewsCategory, page: Int?, date: Date?) async throws -> NewsResult
}
