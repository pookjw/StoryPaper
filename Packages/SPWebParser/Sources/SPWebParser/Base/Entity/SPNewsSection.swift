import Foundation

public protocol SPNewsSection: Sendable, Hashable, CustomStringConvertible {
    associatedtype NewsItem: SPNewsItem
    
    var title: String? { get }
    var badgeText: String? { get }
    var newsItems: [NewsItem] { get }
}

public extension SPNewsSection {
    var description: String {
        var text: String = """
        
        =====
        title: \(String(describing: title))
        badgeText: \(String(describing: badgeText))
        -----
        newsItems:
            -----
        
        """
        
        newsItems
            .forEach { item in
                text += """
                
                    \(item)
                
                    -----
                
                """
            }
        
        text += "===\n"
        
        return text
    }
}
