//
//  ArticlesViewController.swift
//  StoryPaper_iOS
//
//  Created by Jinwoo Kim on 12/18/22.
//

import UIKit
import SPWebParser
import SPLogger

@MainActor
final class ArticlesViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var viewModel: ArticlesViewModel!
    private var updateDataSourceTask: Task<Void, Error>?
    private var openDocumentTask: Task<Void, Error>?
    
    deinit {
        updateDataSourceTask?.cancel()
        openDocumentTask?.cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureViewModel()
    }
    
    func update(news: SPNews, category: any SPNewsCatetory) {
        title = category.text
        
        updateDataSourceTask?.cancel()
        updateDataSourceTask = .detached { [viewModel] in
            try await viewModel?.updateDataSource(news: news, category: category)
        }
    }
    
    private func configureCollectionView() {
        var listConfiguration: UICollectionLayoutListConfiguration = .init(appearance: .insetGrouped)
        listConfiguration.headerMode = .supplementary
        
        let collectionViewLayout: UICollectionViewCompositionalLayout = .list(using: listConfiguration)
        let collectionView: UICollectionView = .init(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.collectionView = collectionView
    }
    
    private func configureViewModel() {
        let dataSource: UICollectionViewDiffableDataSource<ArticlesSectionModel, ArticlesItemModel> = createDataSource()
        let viewModel: ArticlesViewModel = .init(dataSource: dataSource)
        self.viewModel = viewModel
    }
    
    private func createDataSource() -> UICollectionViewDiffableDataSource<ArticlesSectionModel, ArticlesItemModel> {
        let cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, ArticlesItemModel> = createCellRegistration()
        let headerRegistration: UICollectionView.SupplementaryRegistration<UICollectionViewListCell> = createHeaderRegistration()
        
        let dataSource: UICollectionViewDiffableDataSource<ArticlesSectionModel, ArticlesItemModel> = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell: UICollectionViewCell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            switch elementKind {
            case UICollectionView.elementKindSectionHeader:
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            default:
                return nil
            }
        }
        
        return dataSource
    }
    
    private func createCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, ArticlesItemModel> {
        let cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, ArticlesItemModel> = .init { cell, indexPath, itemIdentifier in
            var contentConfiguration: UIListContentConfiguration = .cell()
            contentConfiguration.text = itemIdentifier.title
            contentConfiguration.secondaryText = itemIdentifier.description
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.disclosureIndicator()]
        }
        
        return cellRegistration
    }
    
    private func createHeaderRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        let headerRegistration: UICollectionView.SupplementaryRegistration<UICollectionViewListCell> = .init(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            
        }
        
        return headerRegistration
    }
}

extension ArticlesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openDocumentTask?.cancel()
        openDocumentTask = .detached { [weak collectionView, viewModel] in
            guard let item: ArticlesItemModel = try await viewModel?.item(from: indexPath) else {
                log.error("An item was not found.")
                return
            }
            
            await MainActor.run { [weak collectionView] in
                collectionView?.window?.windowScene?.open(item.documentURL, options: nil)
            }
        }
    }
}
