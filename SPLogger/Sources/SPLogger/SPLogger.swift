import Foundation
import OSLog

public let log: SPLogger = .shared

public final class SPLogger {
    public static let shared: SPLogger = .init()
    
    private let logger: Logger = .init()
    
    private init() {
        
    }
    
    public func notice(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName: String = fileName(for: file)
        logger.notice("\(fileName) - \(function) - \(line) : \(String(describing: message))")
    }
    
    public func debug(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName: String = fileName(for: file)
        logger.debug("\(fileName) - \(function) - \(line) : \(String(describing: message))")
    }
    
    public func trace(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName: String = fileName(for: file)
        logger.trace("\(fileName) - \(function) - \(line) : \(String(describing: message))")
    }
    
    public func info(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName: String = fileName(for: file)
        logger.info("\(fileName) - \(function) - \(line) : \(String(describing: message))")
    }
    
    public func error(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
#if DEBUG
        fatalError("\(message)")
#else
        let fileName: String = fileName(for: file)
        logger.error("\(fileName) - \(function) - \(line) : \(String(describing: message))")
#endif
    }
    
    public func warning(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
#if DEBUG
        fatalError("\(message)")
#else
        let fileName: String = fileName(for: file)
        logger.warning("\(fileName) - \(function) - \(line) : \(String(describing: message))")
#endif
    }
    
    public func fault(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
#if DEBUG
        fatalError("\(message)")
#else
        let fileName: String = fileName(for: file)
        logger.fault("\(fileName) - \(function) - \(line) : \(String(describing: message))")
#endif
    }
    
    public func critical(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
#if DEBUG
        fatalError("\(message)")
#else
        let fileName: String = fileName(for: file)
        logger.critical("\(fileName) - \(function) - \(line) : \(String(describing: message))")
#endif
    }
    
    private func fileName(for filePath: String) -> String {
        let url: URL = .init(filePath: filePath, directoryHint: .notDirectory, relativeTo: nil)
        return url.lastPathComponent
    }
}
