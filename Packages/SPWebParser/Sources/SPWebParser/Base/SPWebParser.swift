import Foundation
import SPLogger

public protocol SPWebParser {
    associatedtype NewsResult: SPNewsResult
    associatedtype NewsCategory: SPNewsCatetory
    
    func newsResultForHome() async throws -> NewsResult
    func newsResult(from newsCategory: NewsCategory) async throws -> NewsResult
    
    func logUnexpectedParsingBehavior(file: String, function: String, line: Int)
}

public extension SPWebParser {
    func logUnexpectedParsingBehavior(file: String = #file, function: String = #function, line: Int = #line) {
        log.warning("Unexpected parsing behavior.", file: file, function: function, line: line)
    }
}
