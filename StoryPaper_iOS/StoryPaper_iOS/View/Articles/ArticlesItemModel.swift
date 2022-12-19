//
//  ArticlesItemModel.swift
//  StoryPaper_iOS
//
//  Created by Jinwoo Kim on 12/20/22.
//

import Foundation

struct ArticlesItemModel: Sendable, Hashable {
    let title: String
    let description: String?
    let thumbnailImageURL: URL?
    let documentURL: URL
    let date: Date?
    let author: String?
}
