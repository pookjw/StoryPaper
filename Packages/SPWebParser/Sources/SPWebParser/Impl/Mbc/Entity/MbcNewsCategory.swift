import Foundation
import SPError
import SPLogger

enum MbcNewsCategory: SPNewsCatetory {
    case home

    case newsDesk
    case nwtoday
    case nw1400
    case newsflash
    case nw930
    case nw1200
    case nw1700
    case straight
    case unity
    
    case politics
    case society
    case world
    case econo
    case culture
    case network
    case sports
    case enter
    case groupnews
    case politicstime
    case todaythisnw
    case streeteco
    case ahplus
    case roadman
    
    case newsinsight
    case turnedout
    case worldnow
    case otbt
    case detecm
    case kindreporters
    case cereport
    case lmkeco
    case seochom
    case vod365
    case issue12
    case pyhotline
    case maxmlb
    
    case mbic
    case _14f

    var text: String {
        let key: String
        
        switch self {
        case .home:
            key = "HOME"
        case .newsDesk:
            key = "NEWSDESK"
        case .nwtoday:
            key = "NWTODAY"
        case .nw1400:
            key = "NW1400"
        case .newsflash:
            key = "NEWSFLASH"
        case .nw930:
            key = "NW930"
        case .nw1200:
            key = "NW1200"
        case .nw1700:
            key = "NW1700"
        case .straight:
            key = "STRAIGHT"
        case .unity:
            key = "UNITY"
        case .politics:
            key = "POLITICS"
        case .society:
            key = "SOCIETY"
        case .world:
            key = "WORLD"
        case .econo:
            key = "ECONO"
        case .culture:
            key = "CULTURE"
        case .network:
            key = "NETWORK"
        case .sports:
            key = "SPORTS"
        case .enter:
            key = "ENTER"
        case .groupnews:
            key = "GROUPNEWS"
        case .politicstime:
            key = "POLITICSTIME"
        case .todaythisnw:
            key = "TODAYTHISNW"
        case .streeteco:
            key = "STREETECO"
        case .ahplus:
            key = "AHPLUS"
        case .roadman:
            key = "ROADMAN"
        case .newsinsight:
            key = "NEWSINSIGHT"
        case .turnedout:
            key = "TURNEDOUT"
        case .worldnow:
            key = "WORLDNOW"
        case .otbt:
            key = "OTBT"
        case .detecm:
            key = "DETECM"
        case .kindreporters:
            key = "KINDREPORTERS"
        case .cereport:
            key = "CEREPORT"
        case .lmkeco:
            key = "LMKECO"
        case .seochom:
            key = "SEOCHOM"
        case .vod365:
            key = "VOD365"
        case .issue12:
            key = "ISSUE12"
        case .pyhotline:
            key = "PYHOTLINE"
        case .maxmlb:
            key = "MAXMLB"
        case .mbic:
            key = "MBIC"
        case ._14f:
            key = "14F"
        }
        
        return NSLocalizedString(key, tableName: "MbcNewsCategory", bundle: .module, comment: .init())
    }
    
    var requestValues: [SPNewsCategoryRequestValue] {
        switch self {
        case .newsDesk,
                .nwtoday,
                .nw1400,
                .nw930,
                .nw1200,
                .nw1700,
                .politics,
                .society,
                .world,
                .econo,
                .culture,
                .sports,
                .enter:
            return [.day(nil)]
        case .mbic,
                .newsflash,
                .straight,
                .unity,
                .network:
            return [.year(nil)]
        case .home,
                .groupnews,
                .politicstime,
                .todaythisnw,
                .streeteco,
                .ahplus,
                .roadman,
                .newsinsight,
                .turnedout,
                .worldnow,
                .otbt,
                .detecm,
                .kindreporters,
                .cereport,
                .lmkeco,
                .seochom,
                .vod365,
                .issue12,
                .pyhotline,
                .maxmlb,
                ._14f:
            return []
        }
    }
    
    func urlComponents(requestFields: Set<SPNewsCategoryRequestValue>) async throws -> URLComponents {
        let path: String

        switch self {
        case .home:
            path = "/operate/common/main/topnews/headline_news.js"
        case .newsDesk:
            let day: Date! = SPNewsCategoryRequestValue.day(from: requestFields)
            let year: Int = try day.year
            path = try await pageAndDayPath(from: "/replay/\(year)/nwdesk/", day: day)
        case .nwtoday:
            let day: Date! = SPNewsCategoryRequestValue.day(from: requestFields)
            let year: Int = try day.year
            path = try await pageAndDayPath(from: "/replay/\(year)/nwtoday/", day: day)
        case .nw1400:
            let day: Date! = SPNewsCategoryRequestValue.day(from: requestFields)
            let year: Int = try day.year
            path = try await pageAndDayPath(from: "/replay/\(year)/nw1400/", day: day)
        case .newsflash:
            let year: Int! = SPNewsCategoryRequestValue.year(from: requestFields)
            path = "/replay/newsflash/\(String(year)).js"
        case .nw930:
            let day: Date! = SPNewsCategoryRequestValue.day(from: requestFields)
            let year: Int = try day.year
            path = try await pageAndDayPath(from: "/replay/\(year)/nw930/", day: day)
        case .nw1200:
            let day: Date! = SPNewsCategoryRequestValue.day(from: requestFields)
            let year: Int = try day.year
            path = try await pageAndDayPath(from: "/replay/\(year)/nw1200/", day: day)
        case .nw1700:
            let day: Date! = SPNewsCategoryRequestValue.day(from: requestFields)
            let year: Int = try day.year
            path = try await pageAndDayPath(from: "/replay/\(year)/nw1700/", day: day)
        case .straight:
            let year: Int! = SPNewsCategoryRequestValue.year(from: requestFields)
            path = "/replay/straight/\(String(year)).js"
        case .unity:
            let year: Int! = SPNewsCategoryRequestValue.year(from: requestFields)
            path = "/replay/unity/\(String(year)).js"
        case .politics:
            let day: Date! = SPNewsCategoryRequestValue.day(from: requestFields)
            let year: Int = try day.year
            path = try await pageAndDayPath(from: "/news/\(year)/politics/", day: day)
        case .society:
            let day: Date! = SPNewsCategoryRequestValue.day(from: requestFields)
            let year: Int = try day.year
            path = try await pageAndDayPath(from: "/news/\(year)/society/", day: day)
        case .world:
            let day: Date! = SPNewsCategoryRequestValue.day(from: requestFields)
            let year: Int = try day.year
            path = try await pageAndDayPath(from: "/news/\(year)/world/", day: day)
        case .econo:
            let day: Date! = SPNewsCategoryRequestValue.day(from: requestFields)
            let year: Int = try day.year
            path = try await pageAndDayPath(from: "/news/\(year)/econo/", day: day)
        case .culture:
            let day: Date! = SPNewsCategoryRequestValue.day(from: requestFields)
            let year: Int = try day.year
            path = try await pageAndDayPath(from: "/news/\(year)/culture/", day: day)
        case .network:
            let year: Int! = SPNewsCategoryRequestValue.year(from: requestFields)
            path = "/news/network/\(year!).js"
        case .sports:
            let day: Date! = SPNewsCategoryRequestValue.day(from: requestFields)
            let year: Int = try day.year
            path = try await pageAndDayPath(from: "/news/\(year)/sports/", day: day)
        case .enter:
            let day: Date! = SPNewsCategoryRequestValue.day(from: requestFields)
            let year: Int = try day.year
            path = try await pageAndDayPath(from: "/news/\(year)/enter/", day: day)
        case .groupnews:
            path = "/newszoomin/groupnews/index.js"
        case .politicstime:
            path = "/newszoomin/politicstime/index.js"
        case .todaythisnw:
            path = "/newszoomin/todaythisnw/index.js"
        case .streeteco:
            path = "/newszoomin/streeteco/index.js"
        case .ahplus:
            path = "/newszoomin/ahplus/index.js"
        case .roadman:
            path = "/newszoomin/roadman/index.js"
        case .newsinsight:
            path = "/newszoomin/roadman/index.js"
        case .turnedout:
            path = "/newszoomin/turnedout/index.js"
        case .worldnow:
            path = "/newszoomin/worldnow/index.js"
        case .otbt:
            path = "/newszoomin/otbt/index.js"
        case .detecm:
            path = "/newszoomin/detecm/index.js"
        case .kindreporters:
            path = "/newszoomin/kindreporters/index.js"
        case .cereport:
            path = "/newszoomin/cereport/index.js"
        case .lmkeco:
            path = "/newszoomin/lmkeco/index.js"
        case .seochom:
            path = "/newszoomin/seochom/index.js"
        case .vod365:
            path = "/newszoomin/vod365/index.js"
        case .issue12:
            path = "/newszoomin/issue12/index.js"
        case .pyhotline:
            path = "/newszoomin/pyhotline/index.js"
        case .maxmlb:
            path = "/newszoomin/maxmlb/index.js"
        case .mbic:
            let year: Int! = SPNewsCategoryRequestValue.year(from: requestFields)
            path = "/original/mbig/\(String(year)).js"
        case ._14f:
            let year: Int! = SPNewsCategoryRequestValue.year(from: requestFields)
            path = "/original/14f/\(String(year)).js"
        }
        
        var urlComponents: URLComponents = .init()
        
        urlComponents.scheme = "https"
        urlComponents.host = "imnews.imbc.com"
        urlComponents.path = path
        
        return urlComponents
    }
    
    private func pageAndDayPath(from path: String, day: Date) async throws -> String {
        var urlComponents: URLComponents = .init()
        
        urlComponents.scheme = "https"
        urlComponents.host = "imnews.imbc.com"
        urlComponents.path = "\(path)cal_data.js"
        
        let configuration: URLSessionConfiguration = .ephemeral
        let session: URLSession = URLSession(configuration: configuration)
        
        guard let url: URL = urlComponents.url else {
            throw SPError.unexpectedNil
        }
        
        log.debug(url)
        
        var request: URLRequest = .init(url: url)
        request.httpMethod = "GET"
        let (data, response): (Data, URLResponse) = try await session.data(for: request)
        
        guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse else {
            throw SPError.typeMismatch
        }
        
        guard httpResponse.statusCode == 200 else {
            throw SPError.invalidHTTPResponseCode(httpResponse.statusCode)
        }
        
        let decoder: JSONDecoder = .init()
        decoder.allowsJSON5 = true
        let calData: MbcNewsCalData = try decoder.decode(MbcNewsCalData.self, from: data)
        
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = .init(identifier: "ko_KR")
        let dayString: String = dateFormatter.string(from: day)
        
        guard let calDataDate: MbcNewsCalData.Date = calData
            .dateList
            .first(where: { $0.day == dayString }) else {
            throw SPError.noAvailableNewsForSpecifiedDate
        }
        
        return "\(path)\(calDataDate.currentId)_\(calData.dataId).js"
    }
}
