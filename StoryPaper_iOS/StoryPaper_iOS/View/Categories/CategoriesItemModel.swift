//
//  CategoriesItemModel.swift
//  StoryPaper_iOS
//
//  Created by Jinwoo Kim on 12/19/22.
//

import Foundation
import SPWebParser

enum CategoriesItemModel: Sendable, Hashable {
    case news(SPNews)
    case category(any SPNewsCatetory)
    
    static func == (lhs: CategoriesItemModel, rhs: CategoriesItemModel) -> Bool {
        switch (lhs, rhs) {
        case let (.news(lhsNews), .news(rhsNews)):
            return lhsNews.hashValue == rhsNews.hashValue
        case let (.category(lhsCategory), .category(rhsCategory)):
            return lhsCategory.hashValue == rhsCategory.hashValue
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .news(spNews):
            hasher.combine(spNews)
        case let .category(spNewsCatetory):
            hasher.combine(spNewsCatetory)
        }
    }
}
