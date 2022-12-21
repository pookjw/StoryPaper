//
//  MainViewController.swift
//  StoryPaper_iOS
//
//  Created by Jinwoo Kim on 12/12/22.
//

import UIKit

@MainActor
final class MainViewController: UIViewController {
    private let mainSplitViewController: MainSplitViewController = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainSplitView()
    }
    
    private func configureMainSplitView() {
        let mainSplitView: UIView = mainSplitViewController.view
        
        view.addSubview(mainSplitView)
        addChild(mainSplitViewController)
        
        mainSplitView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainSplitView.topAnchor.constraint(equalTo: view.topAnchor),
            mainSplitView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainSplitView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainSplitView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
