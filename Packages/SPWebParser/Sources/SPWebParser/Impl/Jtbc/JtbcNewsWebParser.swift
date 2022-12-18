import Foundation
import SPError
import SPLogger
import SwiftSoup

public final class JtbcNewsWebParser {
    
}

extension JtbcNewsWebParser: SPWebParser {
    public typealias NewsResult = JtbcNewsResult
    public typealias NewsCategory = JtbcNewsCategory
    
    public func newsResultForHome() async throws -> JtbcNewsResult {
        try await newsResult(from: .home)
    }
    
    public func newsResult(from newsCategory: JtbcNewsCategory) async throws -> JtbcNewsResult {
        let document: Document = try await document(from: newsCategory)
        
        switch newsCategory.parsingStrategy {
        case .`default`:
            return try await newsResultForDefaultParsingStrategy(from: document)
        case .list:
            return try await newsResultForListParsingStrategy(from: document)
        case .index:
            return try await newsResultForIndexParsingStrategy(from: document)
        case .newsReplay:
            return try await newsResultForNewsReplayParsingStrategy(from: document)
        }
    }
    
    private func newsResultForDefaultParsingStrategy(from document: Document) async throws -> JtbcNewsResult {
        var sections: [JtbcNewsSection] = []
        
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
                        logUnexpectedParsingBehavior()
                        return nil
                    }
                    
                    let thumbnailImageURL: URL?
                    if let thumbnailImageURLString: String = try? ddImgElement.attr("src") {
                        thumbnailImageURL = .init(string: thumbnailImageURLString)
                    } else {
                        logUnexpectedParsingBehavior()
                        thumbnailImageURL = nil
                    }
                    
                    let title: String = dlAElement.ownText()
                    
                    return .init(
                        title: title,
                        description: nil,
                        thumbnailImageURL: thumbnailImageURL,
                        documentURL: documentURL,
                        date: nil,
                        author: nil
                    )
                }
            
            if !showcaseNewsItems.isEmpty {
                sections.append(
                    .init(
                        title: nil,
                        badgeText: nil,
                        newsItems: showcaseNewsItems
                    )
                )
            } else {
                logUnexpectedParsingBehavior()
            }
        } else {
            logUnexpectedParsingBehavior()
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
                logUnexpectedParsingBehavior()
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
                            logUnexpectedParsingBehavior()
                            return
                        }
                        
                        let title: String = aElement.ownText()
                        
                        let thumbnailImageURL: URL?
                        if let thumbnailImageURLString: String = try? imgElement.attr("src") {
                            thumbnailImageURL = .init(string: thumbnailImageURLString)
                        } else {
                            logUnexpectedParsingBehavior()
                            thumbnailImageURL = nil
                        }
                        
                        todayNewsItems.append(
                            .init(
                                title: title,
                                description: nil,
                                thumbnailImageURL: thumbnailImageURL,
                                documentURL: documentURL,
                                date: nil,
                                author: nil
                            )
                        )
                    }
            } else {
                logUnexpectedParsingBehavior()
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
                            logUnexpectedParsingBehavior()
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
                                author: nil
                            )
                        )
                    }
            } else {
                logUnexpectedParsingBehavior()
            }
            
            if !todayNewsItems.isEmpty {
                sections.append(
                    .init(
                        title: sectionTitle,
                        badgeText: nil,
                        newsItems: todayNewsItems
                    )
                )
            } else {
                logUnexpectedParsingBehavior()
            }
        } else {
            logUnexpectedParsingBehavior()
        }
        
        //
        
        if let moduleFeedInElements: Elements = try? document.getElementsByClass("module_feed_in") {
            let moduleFeedNewsSections: [JtbcNewsSection] = moduleFeedInElements
                .compactMap { element -> JtbcNewsSection? in
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
                            logUnexpectedParsingBehavior()
                            title = nil
                        }
                        
                        if let spanElement: Element = try? feedTitElement
                            .getElementsByTag("span")
                            .first() {
                            badgeText = spanElement.ownText()
                        } else {
                            logUnexpectedParsingBehavior()
                            badgeText = nil
                        }
                    } else {
                        logUnexpectedParsingBehavior()
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
                                    logUnexpectedParsingBehavior()
                                    return
                                }
                                
                                aElements
                                    .forEach { element in
                                        guard
                                            let documentURLString: String = try? element.attr("href"),
                                            let documentURL: URL = .init(string: documentURLString)
                                        else {
                                            logUnexpectedParsingBehavior()
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
                                            logUnexpectedParsingBehavior()
                                            return
                                        }
                                        
                                        let thumbnailImageURL: URL?
                                        if let thumbnailImageURLString: String = try? imgElement.attr("src") {
                                            thumbnailImageURL = .init(string: thumbnailImageURLString)
                                        } else {
                                            logUnexpectedParsingBehavior()
                                            thumbnailImageURL = nil
                                        }
                                        
                                        items.append(
                                            .init(
                                                title: strongElement.ownText(),
                                                description: nil,
                                                thumbnailImageURL: thumbnailImageURL,
                                                documentURL: documentURL,
                                                date: nil,
                                                author: nil
                                            )
                                        )
                                    }
                            }
                    }
                    
                    if let txtListElements: Elements = try? element.getElementsByClass("txt-list") {
                        txtListElements
                            .forEach { element in
                                guard let liElements: Elements = try? element.getElementsByTag("li") else {
                                    logUnexpectedParsingBehavior()
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
                                            logUnexpectedParsingBehavior()
                                            return
                                        }
                                        
                                        items.append(
                                            .init(
                                                title: aElement.ownText(),
                                                description: nil,
                                                thumbnailImageURL: nil,
                                                documentURL: documentURL,
                                                date: nil,
                                                author: nil
                                            )
                                        )
                                    }
                            }
                    }
                    
                    //
                    
                    if let timelineListInElements: Elements = try? element.getElementsByClass("timeline_list_in") {
                        timelineListInElements
                            .forEach { element in
                                guard let ddElements: Elements = try? element.getElementsByTag("dd") else {
                                    logUnexpectedParsingBehavior()
                                    return
                                }
                                
                                ddElements
                                    .forEach { element in
                                        guard let aElement: Elements = try? element.getElementsByTag("a") else {
                                            logUnexpectedParsingBehavior()
                                            return
                                        }
                                        
                                        aElement
                                            .forEach { element in
                                                guard
                                                    let href: String = try? element.attr("href"),
                                                    let documentURL: URL = .init(string: href),
                                                    let strongElement: Element = try? element
                                                        .getElementsByTag("strong")
                                                        .first()
                                                else {
                                                    logUnexpectedParsingBehavior()
                                                    return
                                                }
                                                
                                                let thumbnailImageURL: URL?
                                                if
                                                    let imgElement: Element = try? element
                                                        .getElementsByTag("img")
                                                        .first(),
                                                    let src: String = try? imgElement.attr("src")
                                                {
                                                    thumbnailImageURL = .init(string: src)
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
                                                        author: nil
                                                    )
                                                )
                                            }
                                    }
                            }
                    }
                    
                    //
                    
                    guard !items.isEmpty else {
                        logUnexpectedParsingBehavior()
                        return nil
                    }
                    
                    return .init(
                        title: title,
                        badgeText: badgeText,
                        newsItems: items
                    )
                }
            
            //
            
            sections.append(contentsOf: moduleFeedNewsSections)
        } else {
            logUnexpectedParsingBehavior()
        }
        
        //
        
        return .init(
            hasMorePage: false,
            sections: sections
        )
    }
    
    private func newsResultForListParsingStrategy(from document: Document) async throws -> JtbcNewsResult {
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
            logUnexpectedParsingBehavior()
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
                    logUnexpectedParsingBehavior()
                    return nil
                }
                
                let title: String = titleCrAElement.ownText()
                
                var documentURLComponents: URLComponents = .init()
                documentURLComponents.scheme = "https"
                documentURLComponents.host = "news.jtbc.co.kr"
                documentURLComponents.path = href
                
                guard let documentURL: URL = documentURLComponents.url else {
                    logUnexpectedParsingBehavior()
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
                    logUnexpectedParsingBehavior()
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
                    logUnexpectedParsingBehavior()
                    description = nil
                }
                
                //
                
                let date: Date?
                let author: String?
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
                        logUnexpectedParsingBehavior()
                        date = nil
                    }
                    
                    if let writerClass: Element = try? infoElement
                        .getElementsByClass("writer")
                        .first() {
                        author = writerClass.ownText()
                    } else {
                        logUnexpectedParsingBehavior()
                        author = nil
                    }
                } else {
                    logUnexpectedParsingBehavior()
                    date = nil
                    author = nil
                }
                
                return .init(
                    title: title,
                    description: description,
                    thumbnailImageURL: thumbnailImageURL,
                    documentURL: documentURL,
                    date: date,
                    author: author
                )
            }
        
        let hasMorePage: Bool
        if let pargerElement: Element = try? document.getElementById("CPContent_pager") {
            hasMorePage = ((try? pargerElement.getElementsByClass("next").count) ?? .zero) > .zero
        } else {
            // When a page has single page, this will occur.
            hasMorePage = false
        }
        
        guard !items.isEmpty else {
            throw SPError.noAvailableNewsForSpecifiedDate
        }
        
        return .init(
            hasMorePage: hasMorePage,
            sections: [
                .init(title: sectionTitle, badgeText: nil, newsItems: items)
            ]
        )
    }
    
    private func newsResultForIndexParsingStrategy(from document: Document) async throws -> JtbcNewsResult {
        var sections: [JtbcNewsSection] = []
        
        //
        
        if let headlineElement: Element = try? document.getElementById("CPContent_section_headline") {
            let sectionTitle: String?
            if let h3Element: Element = try? headlineElement
                .getElementsByTag("h3")
                .first() {
                sectionTitle = h3Element.ownText()
            } else {
                logUnexpectedParsingBehavior()
                sectionTitle = nil
            }
            
            var items: [JtbcNewsItem] = []
            let handleNewsAreaElements: (Elements) -> Void = { elements in
                elements
                    .forEach { element in
                        guard
                            let dtElement: Element = try? element
                                .getElementsByTag("dt")
                                .first(),
                            let dtAElement: Element = try? dtElement
                                .getElementsByTag("a")
                                .first(),
                            let href: String = try? dtAElement.attr("href")
                        else {
                            self.logUnexpectedParsingBehavior()
                            return
                        }
                        
                        var urlComponents: URLComponents = .init()
                        
                        urlComponents.scheme = "https"
                        urlComponents.host = "news.jtbc.co.kr"
                        urlComponents.path = href
                        
                        guard let documentURL: URL = urlComponents.url else {
                            self.logUnexpectedParsingBehavior()
                            return
                        }
                        
                        let title: String = dtAElement.ownText()
                        
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
                            self.logUnexpectedParsingBehavior()
                            thumbnailImageURL = nil
                        }
                        
                        //
                        
                        let description: String?
                        if
                            let descElement: Element = try? element
                                .getElementsByClass("desc")
                                .first(),
                            let descAElement: Element = try? descElement
                                .getElementsByTag("a")
                                .first()
                        {
                            description = descAElement.ownText()
                        } else {
                            self.logUnexpectedParsingBehavior()
                            description = nil
                        }
                        
                        //
                        
                        let author: String?
                        let date: Date?
                        if let writerElement: Element = try? element
                            .getElementsByClass("writer")
                            .first() {
                            author = writerElement.ownText()
                            
                            if let dateElement: Element = try? writerElement
                                .getElementsByClass("date")
                                .first() {
                                let dateFormatter: DateFormatter = .init()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                                dateFormatter.locale = .init(identifier: "ko_KR")
                                
                                let dateString: String = dateElement.ownText()
                                if let _date: Date = dateFormatter.date(from: dateString) {
                                    date = _date
                                } else {
                                    self.logUnexpectedParsingBehavior()
                                    date = nil
                                }
                            } else {
                                self.logUnexpectedParsingBehavior()
                                date = nil
                            }
                        } else {
                            self.logUnexpectedParsingBehavior()
                            author = nil
                            date = nil
                        }
                        
                        
                        items.append(
                            .init(
                                title: title,
                                description: description,
                                thumbnailImageURL: thumbnailImageURL,
                                documentURL: documentURL,
                                date: date,
                                author: author
                            )
                        )
                    }
            }
            
            //
            
            if let newsAreaOnElements: Elements = try? headlineElement.getElementsByClass("news_area on") {
                handleNewsAreaElements(newsAreaOnElements)
            }
            
            if let newsAreaElements: Elements = try? headlineElement.getElementsByClass("news_area ") {
                handleNewsAreaElements(newsAreaElements)
            }
            
            //
            
            if !items.isEmpty {
                sections.append(.init(title: sectionTitle, badgeText: nil, newsItems: items))
            } else {
                logUnexpectedParsingBehavior()
            }
        } else {
            logUnexpectedParsingBehavior()
        }
        
        //
        
        if let mainListElements: Elements = try? document.getElementsByClass("major_news section section_main_list news_list") {
            mainListElements
                .forEach { element in
                    let sectionTitle: String?
                    if
                        let sectionTitleElement: Element = try? element
                            .getElementsByClass("section_title")
                            .first(),
                        let emElement: Element = try? sectionTitleElement
                            .getElementsByTag("em")
                            .first()
                    {
                        sectionTitle = "\(emElement.ownText())\(sectionTitleElement.ownText())"
                    } else {
                        logUnexpectedParsingBehavior()
                        sectionTitle = nil
                    }
                    
                    //
                    
                    guard let sectionListElement: Element = try? element
                        .getElementById("section_list") else {
                        logUnexpectedParsingBehavior()
                        return
                    }
                    
                    guard let liElements: Elements = try? sectionListElement
                        .getElementsByTag("li") else {
                        logUnexpectedParsingBehavior()
                        return
                    }
                    
                    let items: [JtbcNewsItem] = liElements
                        .compactMap { element -> JtbcNewsItem? in
                            guard
                                let titleElement: Element = try? element
                                    .getElementsByClass("title_cr")
                                    .first(),
                                let titleAElement: Element = try? titleElement
                                    .getElementsByTag("a")
                                    .first(),
                                let href: String = try? titleAElement.attr("href")
                            else {
                                logUnexpectedParsingBehavior()
                                return nil
                            }
                            
                            var urlComponents: URLComponents = .init()
                            
                            urlComponents.scheme = "https"
                            urlComponents.host = "news.jtbc.co.kr"
                            urlComponents.path = href
                            
                            guard let documentURL: URL = .init(string: href) else {
                                logUnexpectedParsingBehavior()
                                return nil
                            }
                            
                            let title: String = titleAElement.ownText()
                            
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
                                self.logUnexpectedParsingBehavior()
                                thumbnailImageURL = nil
                            }
                            
                            //
                            
                            let description: String?
                            if
                                let descElement: Element = try? element
                                    .getElementsByClass("desc")
                                    .first(),
                                let descAElement: Element = try? descElement
                                    .getElementsByTag("a")
                                    .first()
                            {
                                description = descAElement.ownText()
                            } else {
                                self.logUnexpectedParsingBehavior()
                                description = nil
                            }
                            
                            //
                            
                            let date: Date?
                            if let dateElement: Element = try? element
                                .getElementsByClass("date")
                                .first() {
                                let dateFormatter: DateFormatter = .init()
                                dateFormatter.dateFormat = "yyyy-MM-dd a h:mm:ss"
                                dateFormatter.locale = .init(identifier: "ko_KR")
                                
                                let dateString: String = dateElement.ownText()
                                if let _date: Date = dateFormatter.date(from: dateString) {
                                    date = _date
                                } else {
                                    self.logUnexpectedParsingBehavior()
                                    date = nil
                                }
                            } else {
                                self.logUnexpectedParsingBehavior()
                                date = nil
                            }
                            
                            //
                            
                            let author: String?
                            if let writerElement: Element = try? element
                                .getElementsByClass("writer")
                                .first() {
                                author = writerElement.ownText()
                            } else {
                                self.logUnexpectedParsingBehavior()
                                author = nil
                            }
                            
                            
                            return .init(
                                title: title,
                                description: description,
                                thumbnailImageURL: thumbnailImageURL,
                                documentURL: documentURL,
                                date: date,
                                author: author
                            )
                        }
                    
                    if !items.isEmpty {
                        sections.append(.init(title: sectionTitle, badgeText: nil, newsItems: items))
                    } else {
                        logUnexpectedParsingBehavior()
                    }
                }
        } else {
            logUnexpectedParsingBehavior()
        }
        
        //
        
        return .init(
            hasMorePage: false,
            sections: sections
        )
    }
    
    private func newsResultForNewsReplayParsingStrategy(from document: Document) async throws -> JtbcNewsResult {
        var sections: [JtbcNewsSection] = []
        
        if let reviewHeadlineElement: Elements = try? document.getElementsByClass("review_headline_v2") {
            var items: [JtbcNewsItem] = []
            
            reviewHeadlineElement
                .forEach { element in
                    guard let ddElements: Elements = try? element.getElementsByTag("dd") else {
                        return
                    }
                    
                    ddElements
                        .forEach { element in
                            guard
                                let aElement: Element = try? element
                                    .getElementsByTag("a")
                                    .first(),
                                let imgElement: Element = try? element
                                    .getElementsByTag("img")
                                    .first(),
                                let href: String = try? aElement.attr("href"),
                                let documentURL: URL = .init(string: href),
                                let title: String = try? imgElement.attr("alt")
                            else {
                                logUnexpectedParsingBehavior()
                                return
                            }
                            
                            let thumbnailImageURL: URL?
                            if let src: String = try? imgElement.attr("src") {
                                thumbnailImageURL = .init(string: src)
                            } else {
                                logUnexpectedParsingBehavior()
                                thumbnailImageURL = nil
                            }
                            
                            items.append(
                                .init(
                                    title: title,
                                    description: nil,
                                    thumbnailImageURL: thumbnailImageURL,
                                    documentURL: documentURL,
                                    date: nil,
                                    author: nil
                                )
                            )
                        }
                }
            
            if !items.isEmpty {
                sections.append(.init(title: nil, badgeText: nil, newsItems: items))
            } else {
                // 새벽일 경우 당일 날짜의 뉴스가 없을 수 있음 - 이전 날짜나 date를 비울 것
                throw SPError.noAvailableNewsForSpecifiedDate
            }
        }
        
        //
        
        if let reviewListElements: Elements = try? document.getElementsByClass("review_list") {
            reviewListElements
                .forEach { element in
                    guard let bdElements: Elements = try? element.getElementsByClass("bd") else {
                        logUnexpectedParsingBehavior()
                        return
                    }
                    
                    var items: [JtbcNewsItem] = []
                    
                    bdElements
                        .forEach { element in
                            guard let liElements: Elements = try? element.getElementsByTag("li") else {
                                logUnexpectedParsingBehavior()
                                return
                            }
                            
                            let results: [JtbcNewsItem] = liElements
                                .compactMap { element -> JtbcNewsItem? in
                                    guard
                                        let rtElement: Element = try? element
                                            .getElementsByClass("rt")
                                            .first(),
                                        let rtAElement: Element = try? rtElement
                                            .getElementsByTag("a")
                                            .first(),
                                        let href: String = try? rtAElement.attr("href"),
                                        let documentURL: URL = .init(string: href)
                                    else {
                                        logUnexpectedParsingBehavior()
                                        return nil
                                    }
                                    
                                    let title: String = rtAElement.ownText()
                                    
                                    let author: String?
                                    if let nameClassElement: Element = try? rtElement
                                        .getElementsByClass("name")
                                        .first() {
                                        author = nameClassElement.ownText()
                                    } else {
                                        logUnexpectedParsingBehavior()
                                        author = nil
                                    }
                                    
                                    let thumbnailImageURL: URL?
                                    if
                                        let ltElement: Element = try? element
                                            .getElementsByClass("lt")
                                            .first(),
                                        let ltImgElement: Element = try? ltElement
                                            .getElementsByTag("img")
                                            .first(),
                                        let src: String = try? ltImgElement.attr("src")
                                    {
                                        thumbnailImageURL = .init(string: src)
                                    } else {
                                        logUnexpectedParsingBehavior()
                                        thumbnailImageURL = nil
                                    }
                                    
                                    //
                                    
                                    return .init(
                                        title: title,
                                        description: nil,
                                        thumbnailImageURL: thumbnailImageURL,
                                        documentURL: documentURL,
                                        date: nil,
                                        author: author
                                    )
                                }
                            
                            //
                            
                            items.append(contentsOf: results)
                        }
                    
                    //
                    
                    guard !items.isEmpty else {
                        return
                    }
                    
                    let sectionTitle: String?
                    if
                        let hdElement: Element = try? element
                            .getElementsByClass("hd")
                            .first(),
                        let h4Element: Element = try? hdElement
                            .getElementsByTag("h4")
                            .first()
                    {
                        sectionTitle = h4Element.ownText()
                    } else {
                        sectionTitle = nil
                    }
                    
                    sections.append(
                        .init(
                            title: sectionTitle,
                            badgeText: nil,
                            newsItems: items
                        )
                    )
                }
                                
        }
        
        //
        
        return .init(
            hasMorePage: true,
            sections: sections
        )
    }
    
    private func document(from newsCategory: JtbcNewsCategory) async throws -> Document {
        let configuration: URLSessionConfiguration = .ephemeral
        let session: URLSession = URLSession(configuration: configuration)
        
        guard let url: URL = newsCategory.urlComponents.url else {
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
        
        guard let html: String = .init(data: data, encoding: .utf8) else {
            throw SPError.unexpectedNil
        }
        
        let document: Document = try SwiftSoup.parse(html)
        return document
    }
}
