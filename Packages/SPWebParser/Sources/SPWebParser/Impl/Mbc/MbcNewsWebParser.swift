import Foundation
import SPError
import SPLogger

public final class MbcNewsWebParser {
    
}

extension MbcNewsWebParser: SPWebParser {
    public typealias NewsResult = MbcNewsResult
    public typealias NewsCategory = MbcNewsCategory
    
    public func newsResultForHome() async throws -> MbcNewsResult {
        try await newsResult(from: .home)
    }
    
    public func newsResult(from newsCategory: MbcNewsCategory) async throws -> MbcNewsResult {
        guard let url: URL = try await newsCategory.urlComponents.url else {
            throw SPError.unexpectedNil
        }
        
        let data: Data = try await data(from: url)
        
        switch newsCategory {
        case .home:
            return try newsResultForHomeData(from: data)
        default:
            return try newsResultForIndexData(from: data)
        }
    }
    
    private func newsResultForHomeData(from data: Data) throws -> MbcNewsResult {
        let decoder: JSONDecoder = .init()
        decoder.allowsJSON5 = true
        
        let homeData: MbcNewsHomeData = try decoder.decode(MbcNewsHomeData.self, from: data)
        
        var sectionTitleAndItem: [String?: [MbcNewsItem]] = [:]
        
        homeData
            .data
            .forEach { item in
                guard
                    let title: String = item.title,
                    let linkURL: URL = item.linkURL
                else {
                    logUnexpectedParsingBehavior()
                    return
                }
                
                let section: String? = item.section
                let description: String? = item.description
                let imageURL: URL? = item.imageURL
                let author: String? = item.author
                let startDate: Date? = item.startDate
                
                var items: [MbcNewsItem] = sectionTitleAndItem[section] ?? []
                
                items.append(
                    .init(
                        title: title,
                        description: description,
                        thumbnailImageURL: imageURL,
                        documentURL: linkURL,
                        date: startDate,
                        author: author
                    )
                )
                
                sectionTitleAndItem[section] = items
            }
        
        let sections: [MbcNewsSection] = sectionTitleAndItem
            .compactMap { key, items in
                return .init(title: key, badgeText: nil, newsItems: items)
            }
        
        return .init(hasMorePage: false, sections: sections)
    }
    
    private func newsResultForIndexData(from data: Data) throws -> MbcNewsResult {
        let decoder: JSONDecoder = .init()
        decoder.allowsJSON5 = true
        
        let indexData: MbcNewsIndexData = try decoder.decode(MbcNewsIndexData.self, from: data)
        
        var sectionTitleAndItem: [String?: [MbcNewsItem]] = [:]
        
        //
        
        indexData
            .data
            .forEach { data in
                data
                    .list
                    .forEach { item in
                        guard
                            let title: String = item.title,
                            let linkURL: URL = item.linkURL
                        else {
                            logUnexpectedParsingBehavior()
                            return
                        }
                        
                        let section: String? = item.section
                        let description: String? = item.description
                        let imageURL: URL? = item.imageURL
                        let author: String? = item.author
                        let startDate: Date? = item.startDate
                        
                        var items: [MbcNewsItem] = sectionTitleAndItem[section] ?? []
                        
                        items.append(
                            .init(
                                title: title,
                                description: description,
                                thumbnailImageURL: imageURL,
                                documentURL: linkURL,
                                date: startDate,
                                author: author
                            )
                        )
                        
                        sectionTitleAndItem[section] = items
                    }
            }
        
        //
        
        let sections: [MbcNewsSection] = sectionTitleAndItem
            .compactMap { key, items in
                return .init(title: key, badgeText: nil, newsItems: items)
            }
        
        return .init(hasMorePage: false, sections: sections)
    }
    
    private func data(from url: URL) async throws -> Data {
        let configuration: URLSessionConfiguration = .ephemeral
        let session: URLSession = URLSession(configuration: configuration)
        
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
        
        return data
    }
}
