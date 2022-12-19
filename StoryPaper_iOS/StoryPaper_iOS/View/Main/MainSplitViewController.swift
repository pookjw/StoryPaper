//
//  MainSplitViewController.swift
//  StoryPaper_iOS
//
//  Created by Jinwoo Kim on 12/18/22.
//

import UIKit
import SPWebParser

@MainActor
final class MainSplitViewController: UISplitViewController {
    private let categoriesViewController: CategoriesViewController = .init()
    private let articlesViewController: ArticlesViewController = .init()
    private var categorySelectionTask: Task<Void, Never>?
    
    convenience init() {
        self.init(style: .doubleColumn)
        delegate = self
    }
    
    deinit {
        categorySelectionTask?.cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    private func configureViewControllers() {
        setViewController(categoriesViewController, for: .primary)
        setViewController(articlesViewController, for: .secondary)
        
        let categorySelectionStream: AsyncStream<(SPNews, any SPNewsCatetory)> = categoriesViewController.categorySelectionStream
        categorySelectionTask = .detached { [weak articlesViewController, categorySelectionStream] in
            for await (news, category) in categorySelectionStream {
                await MainActor.run { [weak articlesViewController] in
                    articlesViewController?.update(news: news, category: category)
                }
            }
        }
    }
}

extension MainSplitViewController: UISplitViewControllerDelegate {
    
}
