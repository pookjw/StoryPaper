import Foundation
import SPWebParser

public enum JtbcNewsCategory: SPNewsCatetory {
    case breakingNews
    case politics
    case economy
    case society
    case international
    case culture
    case entertainments
    case sports
    case weather
    
    case jtbcNewsroom
    case sangamDongClass
    case politicalDepartmentMeeting
    
    case factCheck
    case closedCamera
    case behindPlus
    
    public var text: String {
        let key: String
        
        switch self {
        case .breakingNews:
            key = "BREAKING_NEWS"
        case .politics:
            key = "POLITICS"
        case .economy:
            key = "ECONOMY"
        case .society:
            key = "SOCIETY"
        case .international:
            key = "INTERNATIONAL"
        case .culture:
            key = "CULTURE"
        case .entertainments:
            key = "ENTERTAINMENTS"
        case .sports:
            key = "SPORTS"
        case .weather:
            key = "WEATHER"
        }
        
        return NSLocalizedString(key, tableName: "JTBCNewsCategory", bundle: .module, comment: "")
    }
}
