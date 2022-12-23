//
//  ArticlesCollectionViewLayout.swift
//  StoryPaper_iOS
//
//  Created by Jinwoo Kim on 12/23/22.
//

import UIKit

@MainActor
final class ArticlesCollectionViewLayout: UICollectionViewCompositionalLayout {
    convenience init() {
        let configuration: UICollectionViewCompositionalLayoutConfiguration = .init()
        
        configuration.scrollDirection = .vertical
        configuration.interSectionSpacing = .zero
        
        self.init(
            sectionProvider: { sectionIndex, environment in
                let item: NSCollectionLayoutItem = .init(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    ),
                    supplementaryItems: []
                )
                
                let group: NSCollectionLayoutGroup = .horizontal(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalWidth(0.5)
                    ),
                    subitems: [item]
                )
                
                let section: NSCollectionLayoutSection = .init(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                
                return section
            },
            configuration: configuration
        )
    }
}
