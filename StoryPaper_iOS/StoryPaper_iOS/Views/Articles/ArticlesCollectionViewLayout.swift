//
//  ArticlesCollectionViewLayout.swift
//  StoryPaper_iOS
//
//  Created by Jinwoo Kim on 12/23/22.
//

import UIKit

@MainActor
protocol ArticlesCollectionViewLayoutDelegate: AnyObject {
    func articlesCollectionViewLayoutNumberOfItems(at sectionIndex: Int) -> Int
    func articlesCollectionViewLayoutSectionSizeLayout(at sectionIndex: Int) -> ArticlesCollectionViewLayout.SectionSizeLayout
}

@MainActor
final class ArticlesCollectionViewLayout: UICollectionViewCompositionalLayout {
    enum SectionSizeLayout {
        case orthogonal
        case list
    }
    
    convenience init(delegate: ArticlesCollectionViewLayoutDelegate) {
        let configuration: UICollectionViewCompositionalLayoutConfiguration = .init()
        
        configuration.scrollDirection = .vertical
        configuration.interSectionSpacing = .zero
        configuration.boundarySupplementaryItems = [
            .init(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                ),
                elementKind: NSStringFromClass(ArticlesCollectionHeaderView.self),
                containerAnchor: .init(
                    edges: [.top]
                ),
                itemAnchor: .init(
                    edges: [.bottom]
                )
            )
        ]
        
        self.init(
            sectionProvider: { [weak delegate] sectionIndex, environment in
                guard let delegate: ArticlesCollectionViewLayoutDelegate else {
                    return nil
                }
                
                let itemsCount: Int = delegate.articlesCollectionViewLayoutNumberOfItems(at: sectionIndex)
                let sizeLayout: SectionSizeLayout = delegate.articlesCollectionViewLayoutSectionSizeLayout(at: sectionIndex)
                
                let group: NSCollectionLayoutGroup
                switch sizeLayout {
                case .orthogonal:
                    let item: NSCollectionLayoutItem = .init(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .fractionalHeight(1.0)
                        ),
                        supplementaryItems: []
                    )
                    group = .horizontal(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .fractionalWidth(0.5)
                        ),
                        subitems: [item]
                    )
                case .list:
                    let item: NSCollectionLayoutItem = .init(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .absolute(100.0)
                        ),
                        supplementaryItems: []
                    )
                    
                    group = .vertical(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .absolute(100.0)
                        ),
                        repeatingSubitem: item,
                        count: itemsCount
                    )
                }
                
                let section: NSCollectionLayoutSection = .init(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                
                return section
            },
            configuration: configuration
        )
    }
}
