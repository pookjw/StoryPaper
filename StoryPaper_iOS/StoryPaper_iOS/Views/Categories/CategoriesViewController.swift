//
//  CategoriesViewController.swift
//  StoryPaper_iOS
//
//  Created by Jinwoo Kim on 12/18/22.
//

import UIKit
import SPWebParser
import SPLogger

@MainActor
final class CategoriesViewController: UIViewController {
    private(set) lazy var categorySelectionStream: AsyncStream<(SPNews, any SPNewsCatetory)> = .init { [weak self] continuation in
        self?.categorySelectionContinuation = continuation
    }
    private var categorySelectionContinuation: AsyncStream<(SPNews, any SPNewsCatetory)>.Continuation?
    private var collectionView: UICollectionView!
    private var viewModel: CategoriesViewModel!
    private var loadDataSourceTask: Task<Void, Never>?
    private var categorySelectionTask: Task<Void, Error>?
    
    deinit {
        loadDataSourceTask?.cancel()
        categorySelectionTask?.cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        configureCollectionView()
        configureViewModel()
        
        loadDataSourceTask = .detached { [weak self, viewModel] in
            await viewModel?.loadDataSource()
            await MainActor.run { [weak self] in
                self?.loadDataSourceTask = nil
            }
        }
    }
    
    private func setAttributes() {
        title = "StoryPaper (DEMO)"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func configureCollectionView() {
        let listConfiguration: UICollectionLayoutListConfiguration = .init(appearance: .sidebar)
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
        let dataSource: UICollectionViewDiffableDataSource<CategoriesSectionModel, CategoriesItemModel> = createDataSource()
        let viewModel: CategoriesViewModel = .init(dataSource: dataSource)
        self.viewModel = viewModel
    }
    
    private func createDataSource() -> UICollectionViewDiffableDataSource<CategoriesSectionModel, CategoriesItemModel> {
        let newsCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, SPNews> = createNewsCellRegistration()
        let categoryCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, SPNewsCatetory> = createCategoryCellRegistration()
        
        let dataSource: UICollectionViewDiffableDataSource<CategoriesSectionModel, CategoriesItemModel> = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell: UICollectionViewCell
            
            switch itemIdentifier {
            case let .news(news):
                cell = collectionView.dequeueConfiguredReusableCell(using: newsCellRegistration, for: indexPath, item: news)
            case let .category(category):
                cell = collectionView.dequeueConfiguredReusableCell(using: categoryCellRegistration, for: indexPath, item: category)
            }
            
            return cell
        }
        
        return dataSource
    }
    
    private func createNewsCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, SPNews> {
        let cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, SPNews> = .init { cell, indexPath, itemIdentifier in
            var contentConfiguration: UIListContentConfiguration = .sidebarCell()
            contentConfiguration.text = itemIdentifier.text
            cell.contentConfiguration = contentConfiguration
            
            let disclosureOptions: UICellAccessory.OutlineDisclosureOptions = .init(style: .header, tintColor: nil)
            cell.accessories = [.outlineDisclosure(options: disclosureOptions)]
            cell.backgroundConfiguration = .clear()
        }
        
        return cellRegistration
    }
    
    private func createCategoryCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, SPNewsCatetory> {
        let cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, SPNewsCatetory> = .init { cell, indexPath, itemIdentifier in
            var contentConfiguration: UIListContentConfiguration = .sidebarCell()
            contentConfiguration.text = itemIdentifier.text
            cell.contentConfiguration = contentConfiguration
        }
        
        return cellRegistration
    }
}

extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categorySelectionTask?.cancel()
        categorySelectionTask = .detached { [weak self, viewModel] in
            guard let result: (SPNews, any SPNewsCatetory) = try await viewModel?.newsAndCategory(from: indexPath) else {
                log.error("An item was not found.")
                return
            }
            
            await MainActor.run { [weak self] in
                self?.categorySelectionContinuation?.yield(result)
                self?.categorySelectionTask = nil
            }
        }
    }
}
