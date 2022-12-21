import Foundation

extension URLComponents {
    func url(removingPercentEncoding: Bool) -> URL? {
        guard let url: URL else {
            return nil
        }
        
        guard removingPercentEncoding,
              let refinedPath: String = url.absoluteString.removingPercentEncoding else {
            return url
        }
        
        return .init(string: refinedPath)
    }
}
