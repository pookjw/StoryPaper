//
//  ArticlesViewController.swift
//  StoryPaper_iOS
//
//  Created by Jinwoo Kim on 12/18/22.
//

import UIKit
import SafariServices
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
        let collectionViewLayout: ArticlesCollectionViewLayout = .init()
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
        let largeCellRegistration: UICollectionView.CellRegistration<UICollectionViewCell, ArticlesItemModel> = .init { cell, indexPath, itemIdentifier in
            let contentConfiguration: ArticlesLargeContentConfiguration = .init(itemModel: itemIdentifier)
            cell.contentConfiguration = contentConfiguration
        }
        
        let dataSource: UICollectionViewDiffableDataSource<ArticlesSectionModel, ArticlesItemModel> = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell: UICollectionViewCell = collectionView.dequeueConfiguredReusableCell(using: largeCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
        return dataSource
    }
}

extension ArticlesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openDocumentTask?.cancel()
        openDocumentTask = .detached { [weak self, viewModel] in
            guard let item: ArticlesItemModel = try await viewModel?.item(from: indexPath) else {
                log.error("An item was not found.")
                return
            }
            
            await MainActor.run { [weak self] in
                let configuration: SFSafariViewController.Configuration = .init()
                configuration.entersReaderIfAvailable = true
                let viewController: SFSafariViewController = .init(url: item.documentURL, configuration: configuration)
                self?.present(viewController, animated: true)
            }
        }
    }
}
