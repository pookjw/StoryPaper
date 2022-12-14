import Foundation
import SPError
import SwiftSoup

public actor JtbcWebParser {
    
}

extension JtbcWebParser: SPWebParser {
    public typealias NewsResult = JtbcNewsResult
    public typealias NewsCategory = JtbcNewsCategory
    
    public func newsSectionsForHome(page: Int?, date: Date?) async throws -> JtbcNewsResult {
        try await newsSections(for: .home, page: page, date: date)
    }
    
    public func newsSections(for newsCategory: JtbcNewsCategory, page: Int?, date: Date?) async throws -> JtbcNewsResult {
        switch newsCategory.parsingStrategy {
        case .`default`:
            return try await newsSectionsForDefaultParsingStrategy(for: newsCategory, page: page, date: date)
        case .list:
            return try await newsSectionsForListParsingStrategy(for: newsCategory, page: page, date: date)
        case .index:
            return try await newsSectionsForIndexParsingStrategy(for: newsCategory, page: page, date: date)
        case .newsReplay:
            return try await newsSectionsForNewsReplayParsingStrategy(for: newsCategory, page: page, date: date)
        case .timelineIssue:
            return try await newsSectionsForTimelineIssueParsingStrategy(for: newsCategory, page: page, date: date)
        case .factCheck:
            return try await newsSectionsForFactCheckParsingStrategy(for: newsCategory, page: page, date: date)
        }
    }
    
    private func newsSectionsForDefaultParsingStrategy(for newsCategory: JtbcNewsCategory, page: Int?, date: Date?) async throws -> JtbcNewsResult {
        let document: Document = try await document(for: newsCategory.baseURLComponents)
        var results: [JtbcNewsSection] = []
        
        //
        
        if
            let showcaseElement: Element = try? document.getElementById("showcase"),
            let dlElements: Elements = try? showcaseElement.getElementsByTag("dl")
        {
            let showcaseNewsItems: [JtbcNewsItem] = dlElements
                .compactMap { dlElement -> JtbcNewsItem? in
                    guard
                        let ddElement: Element = try? dlElement
                            .getElementsByTag("dd")
                            .first(),
                        let dlElement: Element = try? dlElement
                            .getElementsByTag("dt")
                            .first(),
                        let ddImgElement: Element = try? ddElement
                            .getElementsByTag("img")
                            .first(),
                        let dlAElement: Element = try? dlElement
                            .getElementsByTag("a")
                            .first()
                    else {
                        return nil
                    }
                    
                    guard
                        let documentURLString: String = try? dlAElement.attr("href"),
                        let documentURL: URL = .init(string: documentURLString)
                    else {
                        return nil
                    }
                    
                    let thumbnailImageURL: URL?
                    if let thumbnailImageURLString: String = try? ddImgElement.attr("src") {
                        thumbnailImageURL = .init(string: thumbnailImageURLString)
                    } else {
                        thumbnailImageURL = nil
                    }
                    
                    let title: String = dlAElement.ownText()
                    
                    return .init(
                        title: title,
                        description: nil,
                        thumbnailImageURL: thumbnailImageURL,
                        documentURL: documentURL,
                        date: nil,
                        reporterName: nil
                    )
                }
            
            if !showcaseNewsItems.isEmpty {
                results.append(
                    .init(
                        title: nil,
                        badgeText: nil,
                        newsItems: showcaseNewsItems
                    )
                )
            }
        }
        
        //
        
        if let conTodayNewsElement: Element = try? document
            .getElementsByClass("con today_news")
            .first() {
            let sectionTitle: String?
            if
                let todayNewsTitElement: Element = try? document
                    .getElementsByClass("today_news_tit")
                    .first(),
                let spanElement: Element = try? todayNewsTitElement
                    .getElementsByTag("span")
                    .first()
            {
                sectionTitle = spanElement.ownText()
            } else {
                sectionTitle = nil
            }
            
            var todayNewsItems: [JtbcNewsItem] = []
            
            if let imgElements: Elements = try? conTodayNewsElement.getElementsByClass("img") {
                imgElements
                    .forEach { element in
                        guard
                            let aElement: Element = try? element
                                .getElementsByTag("a")
                                .first(),
                            let imgElement: Element = try? aElement
                                .getElementsByTag("span")
                                .compactMap({ spanElement in
                                    return try? spanElement
                                        .getElementsByTag("img")
                                        .first
                                })
                                .first,
                            let documentURLString: String = try? aElement
                                .attr("href"),
                            let documentURL: URL = .init(string: documentURLString)
                        else {
                            return
                        }
                        
                        let title: String = aElement.ownText()
                        
                        let thumbnailImageURL: URL?
                        if let thumbnailImageURLString: String = try? imgElement.attr("src") {
                            thumbnailImageURL = .init(string: thumbnailImageURLString)
                        } else {
                            thumbnailImageURL = nil
                        }
                        
                        todayNewsItems.append(
                            .init(
                                title: title,
                                description: nil,
                                thumbnailImageURL: thumbnailImageURL,
                                documentURL: documentURL,
                                date: nil,
                                reporterName: nil
                            )
                        )
                    }
            }
            
            if let normalElements: Elements = try? conTodayNewsElement.getElementsByClass("normal") {
                normalElements
                    .forEach { element in
                        guard
                            let aElement: Element = try? element
                                .getElementsByTag("a")
                                .first(),
                            let documentURLString: String = try? aElement
                                .attr("href"),
                            let documentURL: URL = .init(string: documentURLString)
                        else {
                            return
                        }
                        
                        let title: String = aElement.ownText()
                        
                        todayNewsItems.append(
                            .init(
                                title: title,
                                description: nil,
                                thumbnailImageURL: nil,
                                documentURL: documentURL,
                                date: nil,
                                reporterName: nil
                            )
                        )
                    }
            }
            
            if !todayNewsItems.isEmpty {
                results.append(
                    .init(
                        title: sectionTitle,
                        badgeText: nil,
                        newsItems: todayNewsItems
                    )
                )
            }
        }
        
        //
        
        if let moduleFeedInElements: Elements = try? document.getElementsByClass("module_feed_in") {
            let moduleFeedNewsSections: [JtbcNewsSection] = moduleFeedInElements
                .compactMap { element in
                    let title: String?
                    let badgeText: String?
                    if let feedTitElement: Element = try? element
                        .getElementsByClass("feed_tit")
                        .first() {
                        if let strongElement: Element = try? feedTitElement
                            .getElementsByTag("strong")
                            .first() {
                            title = strongElement.ownText()
                        } else {
                            title = nil
                        }
                        
                        if let spanElement: Element = try? feedTitElement
                            .getElementsByTag("span")
                            .first() {
                            badgeText = spanElement.ownText()
                        } else {
                            badgeText = nil
                        }
                    } else {
                        title = nil
                        badgeText = nil
                    }
                    
                    //
                    
                    var items: [JtbcNewsItem] = []
                    
                    if let imgElements: Elements = try? element
                        .getElementsByClass("feed_img") {
                        imgElements
                            .forEach { element in
                                guard let aElements: Elements = try? element.getElementsByTag("a") else {
                                    return
                                }
                                
                                aElements
                                    .forEach { element in
                                        guard
                                            let documentURLString: String = try? element.attr("href"),
                                            let documentURL: URL = .init(string: documentURLString)
                                        else {
                                            return
                                        }
                                        
                                        guard
                                            let imgElement: Element = try? element
                                                .getElementsByTag("img")
                                                .first(),
                                            let strongElement: Element = try? element
                                                .getElementsByTag("strong")
                                                .first()
                                        else {
                                            return
                                        }
                                        
                                        let thumbnailImageURL: URL?
                                        if let thumbnailImageURLString: String = try? imgElement.attr("src") {
                                            thumbnailImageURL = .init(string: thumbnailImageURLString)
                                        } else {
                                            thumbnailImageURL = nil
                                        }
                                        
                                        items.append(
                                            .init(
                                                title: strongElement.ownText(),
                                                description: nil,
                                                thumbnailImageURL: thumbnailImageURL,
                                                documentURL: documentURL,
                                                date: nil,
                                                reporterName: nil
                                            )
                                        )
                                    }
                            }
                    }
                    
                    if let txtListElements: Elements = try? element.getElementsByClass("txt-list") {
                        txtListElements
                            .forEach { element in
                                guard let liElements: Elements = try? element.getElementsByTag("li") else {
                                    return
                                }
                                
                                liElements
                                    .forEach { element in
                                        guard
                                            let aElement: Element = try? element
                                                .getElementsByTag("a")
                                                .first(),
                                            let documentURLString: String = try? aElement
                                                .attr("href"),
                                            let documentURL: URL = .init(string: documentURLString)
                                        else {
                                            return
                                        }
                                        
                                        items.append(
                                            .init(
                                                title: aElement.ownText(),
                                                description: nil,
                                                thumbnailImageURL: nil,
                                                documentURL: documentURL,
                                                date: nil,
                                                reporterName: nil
                                            )
                                        )
                                    }
                            }
                    }
                    
                    guard !items.isEmpty else {
                        return nil
                    }
                    
                    return .init(
                        title: title,
                        badgeText: badgeText,
                        newsItems: items
                    )
                }
            
            results.append(contentsOf: moduleFeedNewsSections)
        }
        
        //
        
        return .init(
            page: nil,
            sections: results
        )
    }
    
    private func newsSectionsForListParsingStrategy(for newsCategory: JtbcNewsCategory, page: Int?, date: Date?) async throws -> JtbcNewsResult {
        var urlComponents: URLComponents = newsCategory.baseURLComponents
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        
        if let page: Int {
            let pgiQueryItem: URLQueryItem = .init(name: "pgi", value: String(page))
            queryItems.append(pgiQueryItem)
        }
        
        if let date: Date {
            let dateFormatter: DateFormatter = .init()
            dateFormatter.dateFormat = "yyyyMMdd"
            let pdate: String = dateFormatter.string(from: date)
            let pdateQueryItem: URLQueryItem = .init(name: "pdate", value: pdate)
            queryItems.append(pdateQueryItem)
        }
        
        //        let date: Date
        //        if let page: Int {
        //            let currentDate: Date = .init()
        //            let calendar: Calendar = .init(identifier: .gregorian)
        //            var components: DateComponents = .init(calendar: calendar)
        //            components.day = -page
        //
        //            guard let finalDate = calendar.date(byAdding: components, to: currentDate) else {
        //                throw SPError.exceedPage
        //            }
        //
        //            date = finalDate
        //        } else {
        //            date = .init()
        //        }
        
        urlComponents.queryItems = queryItems
        
        let document: Document = try await document(for: urlComponents)
        
        //
        
        let sectionTitle: String?
        if let dOnFirstChildElement: Element = try? document
            .getElementsByClass("d on first_child")
            .first() {
            sectionTitle = dOnFirstChildElement.ownText()
        } else if let dOnElement: Element = try? document
            .getElementsByClass("d on")
            .first() {
            sectionTitle = dOnElement.ownText()
        } else if let dOnEndChild: Element = try? document
            .getElementsByClass("d on end_child")
            .first() {
            sectionTitle = dOnEndChild.ownText()
        } else {
            sectionTitle = nil
        }
        
        //
        
        guard
            let sectionListElement: Element = try? document.getElementById("section_list"),
            let liElements: Elements = try? sectionListElement.getElementsByTag("li")
        else {
            throw SPError.exceedPage
        }
        
        let items: [JtbcNewsItem] = liElements
            .compactMap { element -> JtbcNewsItem? in
                guard
                    let titleCrElement: Element = try? element
                        .getElementsByClass("title_cr")
                        .first(),
                    let titleCrAElement: Element = try? titleCrElement
                        .getElementsByTag("a")
                        .first(),
                    let href: String = try? titleCrElement.attr("href")
                else {
                    return nil
                }
                
                let title: String = titleCrAElement.ownText()
                
                var documentURLComponents: URLComponents = .init()
                documentURLComponents.scheme = "https"
                documentURLComponents.host = "news.jtbc.co.kr"
                documentURLComponents.path = href
                
                guard let documentURL: URL = documentURLComponents.url else {
                    return nil
                }
                
                //
                
                let thumbnailImageURL: URL?
                if
                    let photoElement: Element = try? element
                        .getElementsByClass("photo")
                        .first(),
                    let imgElement: Element = try? photoElement
                        .getElementsByTag("img")
                        .first(),
                    let src: String = try? imgElement.attr("src")
                {
                    thumbnailImageURL = .init(string: src)
                } else {
                    thumbnailImageURL = nil
                }
                
                //
                
                let description: String?
                if
                    let descReadCr: Element = try? element
                        .getElementsByClass("desc read_cr")
                        .first(),
                    let aElement: Element = try? descReadCr
                        .getElementsByTag("a")
                        .first()
                {
                    description = aElement.ownText()
                } else {
                    description = nil
                }
                
                //
                
                let date: Date?
                let reporterName: String?
                if let infoElement: Element = try? element
                    .getElementsByClass("info")
                    .first() {
                    if let dateClass: Element = try? infoElement
                        .getElementsByClass("date")
                        .first() {
                        let dateString: String = dateClass.ownText()
                        let dateFormatter: DateFormatter = .init()
                        dateFormatter.dateFormat = "yyyy-MM-dd a h:mm:ss"
                        dateFormatter.locale = .init(identifier: "ko_KR")
                        
                        date = dateFormatter.date(from: dateString)
                    } else {
                        date = nil
                    }
                    
                    if let writerClass: Element = try? infoElement
                        .getElementsByClass("writer")
                        .first() {
                        reporterName = writerClass.ownText()
                    } else {
                        reporterName = nil
                    }
                } else {
                    date = nil
                    reporterName = nil
                }
                
                return .init(
                    title: title,
                    description: description,
                    thumbnailImageURL: thumbnailImageURL,
                    documentURL: documentURL,
                    date: date,
                    reporterName: reporterName
                )
            }
        
        let currentPage: Int
        let hasMorePage: Bool
        if let pargerElement: Element = try? document.getElementById("CPContent_pager") {
            hasMorePage = ((try? pargerElement.getElementsByClass("next").count) ?? .zero) > .zero
            
            if
                let numSelectedClass: Element = try? pargerElement
                    .getElementsByClass("num selected")
                    .first(),
                let number: Int = Int(numSelectedClass.ownText())
            {
                currentPage = number
            } else {
                currentPage = page ?? 1
            }
        } else {
            currentPage = page ?? 1
            hasMorePage = false
        }
        let page: JtbcNewsResult.Page = .init(currentPage: currentPage, hasMorePage: hasMorePage)
        
        return .init(page: page, sections: [.init(title: sectionTitle, badgeText: nil, newsItems: items)])
    }
    
    private func newsSectionsForNewsReplayParsingStrategy(for newsCategory: JtbcNewsCategory, page: Int?, date: Date?) async throws -> JtbcNewsResult {
        fatalError()
    }
    
    private func newsSectionsForIndexParsingStrategy(for newsCategory: JtbcNewsCategory, page: Int?, date: Date?) async throws -> JtbcNewsResult {
        fatalError()
    }
    
    private func newsSectionsForTimelineIssueParsingStrategy(for newsCategory: JtbcNewsCategory, page: Int?, date: Date?) async throws -> JtbcNewsResult {
        fatalError()
    }
    
    private func newsSectionsForFactCheckParsingStrategy(for newsCategory: JtbcNewsCategory, page: Int?, date: Date?) async throws -> JtbcNewsResult {
        fatalError()
    }
    
    private func document(for urlComponents: URLComponents) async throws -> Document {
        let configuration: URLSessionConfiguration = .ephemeral
        let session: URLSession = URLSession(configuration: configuration)
        
        guard let url: URL = urlComponents.url else {
            throw SPError.unexpectedNil
        }
        
        var request: URLRequest = .init(url: url)
        request.httpMethod = "GET"
        let (data, response): (Data, URLResponse) = try await session.data(for: request)
        
        guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse else {
            throw SPError.typeMismatch
        }
        
        guard httpResponse.statusCode == 200 else {
            throw SPError.invalidHTTPResponseCode(httpResponse.statusCode)
        }
        
        guard let html: String = .init(data: data, encoding: .utf8) else {
            throw SPError.unexpectedNil
        }
        
        let document: Document = try SwiftSoup.parse(html)
        return document
    }
}
