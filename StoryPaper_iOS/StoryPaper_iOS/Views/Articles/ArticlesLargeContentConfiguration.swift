//
//  ArticlesLargeContentConfiguration.swift
//  StoryPaper_iOS
//
//  Created by Jinwoo Kim on 12/23/22.
//

import UIKit

@MainActor
struct ArticlesLargeContentConfiguration: UIContentConfiguration, Sendable {
    let itemModel: ArticlesItemModel
    
    func makeContentView() -> UIView & UIContentView {
        ArticlesLargeContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> ArticlesLargeContentConfiguration {
        self
    }
}
