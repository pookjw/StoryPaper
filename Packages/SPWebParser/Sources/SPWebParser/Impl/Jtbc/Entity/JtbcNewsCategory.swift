import Foundation

public enum JtbcNewsCategory: SPNewsCatetory {
    case home
    
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
    case sangamdongClass
    case politicalDepartmentMeeting
    
    case factCheck
    case closedCamera
    case behindPlus
    
    public var text: String {
        let key: String
        
        switch self {
        case .home:
            key = "HOME"
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
        case .jtbcNewsroom:
            key = "JTBC_NEWSROOM"
        case .sangamdongClass:
            key = "SANGAMDONG_CLASS"
        case .politicalDepartmentMeeting:
            key = "POLITICAL_DEPARTMENT_MEETING"
        case .factCheck:
            key = "FACT_CHECK"
        case .closedCamera:
            key = "CLOSED_CAMERA"
        case .behindPlus:
            key = "BEHIND_PLUS"
        }
        
        return NSLocalizedString(key, tableName: "JTBCNewsCategory", bundle: .module, comment: "")
    }
    
    var baseURLComponents: URLComponents {
        let path: String
        let queryItems: [URLQueryItem]?
        
        switch self {
        case .home:
            path = "/default.aspx"
            queryItems = nil
        case .breakingNews:
            path = "/section/list.aspx"
            queryItems = [.init(name: "scode", value: nil)]
        case .politics:
            path = "/section/index.aspx"
            queryItems = [.init(name: "scode", value: "10")]
        case .economy:
            path = "/section/index.aspx"
            queryItems = [.init(name: "scode", value: "20")]
        case .society:
            path = "/section/index.aspx"
            queryItems = [.init(name: "scode", value: "30")]
        case .international:
            path = "/section/index.aspx"
            queryItems = [.init(name: "scode", value: "40")]
        case .culture:
            path = "/section/index.aspx"
            queryItems = [.init(name: "scode", value: "50")]
        case .entertainments:
            path = "/section/index.aspx"
            queryItems = [.init(name: "scode", value: "60")]
        case .sports:
            path = "/section/index.aspx"
            queryItems = [.init(name: "scode", value: "70")]
        case .weather:
            path = "/section/index.aspx"
            queryItems = [.init(name: "scode", value: "80")]
        case .jtbcNewsroom:
            path = "/Replay/news_replay.aspx"
            queryItems = [.init(name: "fcode", value: "PR10000403")]
        case .sangamdongClass:
            path = "/Replay/news_replay.aspx"
            queryItems = [.init(name: "fcode", value: "PR10010250")]
        case .politicalDepartmentMeeting:
            path = "/Replay/news_replay.aspx"
            queryItems = [.init(name: "fcode", value: "PR10010301")]
        case .factCheck:
            path = "/factcheck"
            queryItems = nil
        case .closedCamera:
            path = "/hotissue/timeline_Issue.aspx"
            queryItems = [
                .init(name: "comp_id", value: "NC10011403"),
                .init(name: "mgubun", value: "news9")
            ]
        case .behindPlus:
            path = "/hotissue/timeline_Issue.aspx"
            queryItems = [
                .init(name: "comp_id", value: "NC10012518"),
                .init(name: "mgubun", value: "news9")
            ]
        }
        
        var urlComponents: URLComponents = .init()
        
        urlComponents.scheme = "https"
        urlComponents.host = "news.jtbc.co.kr"
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
        return urlComponents
    }
    
    var parsingStrategy: JtbcNewsParsingStrategy {
        switch self {
        case .home:
            return .`default`
        case .breakingNews:
            return .list
        case .politics, .economy, .society, .international, .culture, .entertainments, .sports, .weather:
            return .index
        case .jtbcNewsroom, .sangamdongClass, .politicalDepartmentMeeting:
            return .newsReplay
        case .factCheck:
            return .factCheck
        case .closedCamera, .behindPlus:
            return .timelineIssue
        }
    }
}
