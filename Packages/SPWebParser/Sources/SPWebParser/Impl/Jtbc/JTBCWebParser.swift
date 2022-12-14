import Foundation
import SPError
import SwiftSoup

public actor JtbcWebParser {
    
}

extension JtbcWebParser: SPWebParser {
    public typealias NewsSection = JtbcNewsSection
    public typealias NewsCategory = JtbcNewsCategory
    
    public func newsSectionsForHome() async throws -> [JtbcNewsSection] {
        try await newsSections(for: .home)
    }
    
    public func newsSections(for newsCategory: JtbcNewsCategory) async throws -> [JtbcNewsSection] {
        let configuration: URLSessionConfiguration = .ephemeral
        let session: URLSession = URLSession(configuration: configuration)
        var request: URLRequest = .init(url: newsCategory.url)
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
        
        switch newsCategory.parsingStrategy {
        case .`default`:
            return newsSectionsForDefaultParsingStrategy(for: document)
        case .list:
            return try await newsSectionsForListParsingStrategy(for: document)
        case .index:
            return try await newsSectionsForIndexParsingStrategy(for: document)
        case .newsReplay:
            return try await newsSectionsForNewsReplayParsingStrategy(for: document)
        case .timelineIssue:
            return try await newsSectionsForTimelineIssueParsingStrategy(for: document)
        case .factCheck:
            return try await newsSectionsForFactCheckParsingStrategy(for: document)
        }
    }
    
    private func newsSectionsForDefaultParsingStrategy(for document: Document) -> [JtbcNewsSection] {
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
                        date: nil
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
                                date: nil
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
                                date: nil
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
                                                date: nil
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
                                                date: nil
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
        
        return results
    }
    
    private func newsSectionsForListParsingStrategy(for document: Document) async throws -> [JtbcNewsSection] {
        fatalError()
    }
    
    private func newsSectionsForNewsReplayParsingStrategy(for document: Document) async throws -> [JtbcNewsSection] {
        fatalError()
    }
    
    private func newsSectionsForIndexParsingStrategy(for document: Document) async throws -> [JtbcNewsSection] {
        fatalError()
    }
    
    private func newsSectionsForTimelineIssueParsingStrategy(for document: Document) async throws -> [JtbcNewsSection] {
        fatalError()
    }
    
    private func newsSectionsForFactCheckParsingStrategy(for document: Document) async throws -> [JtbcNewsSection] {
        fatalError()
    }
}
