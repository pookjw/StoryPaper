import Foundation
import SPLogger

public protocol SPWebParser {
    func newsResultForHome(requestValues: Set<SPNewsCategoryRequestValue>) async throws -> any SPNewsResult
    func newsResult(from newsCategory: any SPNewsCatetory, requestValues: Set<SPNewsCategoryRequestValue>) async throws -> any SPNewsResult
    
    func logUnexpectedParsingBehavior(file: String, function: String, line: Int)
}

public extension SPWebParser {
    func logUnexpectedParsingBehavior(file: String = #file, function: String = #function, line: Int = #line) {
        log.warning("Unexpected parsing behavior.", file: file, function: function, line: line)
    }
}
