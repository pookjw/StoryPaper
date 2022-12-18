//
//  MainSplitViewController.swift
//  StoryPaper_iOS
//
//  Created by Jinwoo Kim on 12/18/22.
//

import UIKit

@MainActor
final class MainSplitViewController: UISplitViewController {
    private let categoriesViewController: CategoriesViewController = .init()
    private let articlesViewController: ArticlesViewController = .init()
    
    convenience init() {
        self.init(style: .doubleColumn)
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController(categoriesViewController, for: .primary)
        setViewController(articlesViewController, for: .secondary)
    }
}

extension MainSplitViewController: UISplitViewControllerDelegate {
    
}
