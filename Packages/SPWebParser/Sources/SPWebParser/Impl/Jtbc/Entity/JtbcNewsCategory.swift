import Foundation

public enum JtbcNewsCategory: SPNewsCatetory {
    case home
    
    case breakingNews((page: Int, day: Date))
    case politics
    case economy
    case society
    case international
    case culture
    case entertainments
    case sports
    case weather
    
    case jtbcNewsroom(Date)
    case sangamdongClass(Date)
    case politicalDepartmentMeeting(Date)
    
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
        }
        
        return NSLocalizedString(key, tableName: "JtbcNewsCategory", bundle: .module, comment: .init())
    }
    
    public var requestDateComponent: SPNewsRequestDateComponent? {
        switch self {
        case .breakingNews, .jtbcNewsroom, .sangamdongClass, .politicalDepartmentMeeting:
            return .day
        default:
            return nil
        }
    }
    
    var urlComponents: URLComponents {
        let path: String
        let queryItems: [URLQueryItem]?
        
        switch self {
        case .home:
            path = "/default.aspx"
            queryItems = nil
        case let .breakingNews(data):
            path = "/section/list.aspx"
            queryItems = [
                .init(name: "scode", value: nil),
                .init(name: "pgi", value: String(data.page)),
                .init(name: "pdate", value: dateFormatter.string(from: data.day))
            ]
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
        case let .jtbcNewsroom(day):
            path = "/Replay/news_replay.aspx"
            queryItems = [
                .init(name: "fcode", value: "PR10000403"),
                .init(name: "strSearchDate", value: dateFormatter.string(from: day))
            ]
        case let .sangamdongClass(day):
            path = "/Replay/news_replay.aspx"
            queryItems = [
                .init(name: "fcode", value: "PR10010250"),
                .init(name: "strSearchDate", value: dateFormatter.string(from: day))
            ]
        case let .politicalDepartmentMeeting(day):
            path = "/Replay/news_replay.aspx"
            queryItems = [
                .init(name: "fcode", value: "PR10010301"),
                .init(name: "strSearchDate", value: dateFormatter.string(from: day))
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
        }
    }
    
    private var dateFormatter: DateFormatter {
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = .init(identifier: "ko_KR")
        return dateFormatter
    }
}
