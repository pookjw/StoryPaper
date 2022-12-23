//
//  ArticlesViewModel.swift
//  StoryPaper_iOS
//
//  Created by Jinwoo Kim on 12/20/22.
//

import UIKit
import SPWebParser
import SPError
import SPLogger

actor ArticlesViewModel {
    @MainActor private(set) var numberOfItems: [Int: Int] = [:]
    
    private let dataSource: UICollectionViewDiffableDataSource<ArticlesSectionModel, ArticlesItemModel>
    
    init(dataSource: UICollectionViewDiffableDataSource<ArticlesSectionModel, ArticlesItemModel>) {
        self.dataSource = dataSource
    }
    
    func updateDataSource(news: SPNews, category: any SPNewsCatetory) async throws {
        let webParser: any SPWebParser = news.webParser
        
        // TODO: requestValues
        let result: any SPNewsResult = try await webParser.newsResult(from: category, requestValues: [.page(1), .day(.init()), .year(2022)])
        log.debug(result)
        
        //
        
        var snapshot: NSDiffableDataSourceSnapshot<ArticlesSectionModel, ArticlesItemModel> = .init()
        
        result
            .sections
            .forEach { newsSection in
                let title: String?
                if let _title: String = newsSection.title {
                    if let badgeText: String = newsSection.badgeText {
                        title = "[\(badgeText)] \(_title)"
                    } else {
                        title = _title
                    }
                } else {
                    title = nil
                }
                
                let section: ArticlesSectionModel = .init(title: title)
                let items: [ArticlesItemModel] = newsSection
                    .newsItems
                    .compactMap { newsItem -> ArticlesItemModel? in
                        return .init(
                            title: newsItem.title,
                            description: newsItem.description,
                            thumbnailImageURL: newsItem.thumbnailImageURL,
                            documentURL: newsItem.documentURL,
                            date: newsItem.date,
                            author: newsItem.author
                        )
                    }
                
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }
        
        //
        
        var numberOfItems: [Int: Int] = [:]
        snapshot
            .sectionIdentifiers
            .enumerated()
            .forEach { index, section in
                numberOfItems[index] = snapshot.numberOfItems(inSection: section)
            }
        
        await MainActor.run { [weak self, numberOfItems] in
            self?.numberOfItems = numberOfItems
        }
        
        //
        
        await dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func item(from indexPath: IndexPath) async throws -> ArticlesItemModel {
        guard let item: ArticlesItemModel = await dataSource.itemIdentifier(for: indexPath) else {
            throw SPError.unexpectedNil
        }
        
        return item
    }
}
