import Foundation
import OSLog

public let log: SPLogger = .shared

public final class SPLogger {
    public static let shared: SPLogger = .init()
    
    private let logger: Logger = .init()
    
    private init() {
        
    }
    
    public func notice(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        logger.notice("\(file) - \(function) - \(line) : \(String(describing: message))")
    }
    
    public func debug(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        logger.debug("\(file) - \(function) - \(line) : \(String(describing: message))")
    }
    
    public func trace(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        logger.trace("\(file) - \(function) - \(line) : \(String(describing: message))")
    }
    
    public func info(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        logger.info("\(file) - \(function) - \(line) : \(String(describing: message))")
    }
    
    public func error(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        logger.error("\(file) - \(function) - \(line) : \(String(describing: message))")
    }
    
    public func warning(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        logger.warning("\(file) - \(function) - \(line) : \(String(describing: message))")
    }
    
    public func fault(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        logger.fault("\(file) - \(function) - \(line) : \(String(describing: message))")
    }
    
    public func critical(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        logger.critical("\(file) - \(function) - \(line) : \(String(describing: message))")
    }
}
