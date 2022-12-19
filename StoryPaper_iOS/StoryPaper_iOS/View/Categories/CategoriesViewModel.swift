//
//  CategoriesViewModel.swift
//  StoryPaper_iOS
//
//  Created by Jinwoo Kim on 12/19/22.
//

import UIKit
import SPWebParser
import SPError

actor CategoriesViewModel {
    private let dataSource: UICollectionViewDiffableDataSource<CategoriesSectionModel, CategoriesItemModel>
    
    init(dataSource: UICollectionViewDiffableDataSource<CategoriesSectionModel, CategoriesItemModel>) {
        self.dataSource = dataSource
    }
    
    func loadDataSource() async {
        var snapshot: NSDiffableDataSourceSectionSnapshot<CategoriesItemModel> = .init()
        
        SPNews
            .allCases
            .forEach { news in
                let parent: CategoriesItemModel = .news(news)
                let children: [CategoriesItemModel] = news
                    .categories
                    .map { .category($0) }
                snapshot.append([parent], to: nil)
                snapshot.append(children, to: parent)
            }
        
//        await dataSource.apply(snapshot, to: .main, animatingDifferences: true)
        await withCheckedContinuation { [snapshot] continuation in
            Task { @MainActor in
                dataSource.apply(snapshot, to: .main, animatingDifferences: true) {
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    func newsAndCategory(from indexPath: IndexPath) async throws -> (SPNews, any SPNewsCatetory) {
        let snapshot: NSDiffableDataSourceSectionSnapshot<CategoriesItemModel> = dataSource.snapshot(for: .main)
        
        guard
            let child: CategoriesItemModel = await dataSource.itemIdentifier(for: indexPath),
            let parent: CategoriesItemModel = snapshot.parent(of: child),
            case let .news(news) = parent,
            case let .category(category) = child
        else {
            throw SPError.unexpectedNil
        }
        
        return (news, category)
    }
}
