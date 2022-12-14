import Foundation

public enum SPError: LocalizedError {
    case typeMismatch
    case unexpectedNil
    case invalidHTTPResponseCode(Int)
    case exceedPage
    
    public var errorDescription: String? {
        switch self {
        case .typeMismatch:
            return localizedString(for: "TYPE_MISMATCH")
        case .unexpectedNil:
            return localizedString(for: "UNEXPECTED_NIL")
        case let .invalidHTTPResponseCode(code):
            return String(format: localizedString(for: "INVALID_HTTPS_RESPONSE_CODE"), arguments: ["\(code)"])
        case .exceedPage:
            return localizedString(for: "EXCEED_PAGE")
        }
    }
    
    private func localizedString(for key: String) -> String {
        NSLocalizedString(key, tableName: "SPError", bundle: .module, comment: "")
    }
}
