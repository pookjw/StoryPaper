import Foundation
import SPLogger

public protocol SPWebParser {
    associatedtype NewsResult: SPNewsResult
    associatedtype NewsCategory: SPNewsCatetory
    
    func newsSectionsForHome(page: Int?, date: Date?) async throws -> NewsResult
    func newsSections(for newsCategory: NewsCategory, page: Int?, date: Date?) async throws -> NewsResult
    
    func logUnexpectedParsingBehavior(file: String, function: String, line: Int)
}

public extension SPWebParser {
    func logUnexpectedParsingBehavior(file: String = #file, function: String = #function, line: Int = #line) {
        log.warning("Unexpected parsing behavior.", file: file, function: function, line: line)
    }
}
