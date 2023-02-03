//
//  NewsModel.swift
//  RSSReader
//
//  Created by zuzex-62 on 29.12.2022.
//

import Foundation

struct NewsModel {
    var id: String
    var title: String
    var link: String
    var description: String
    var imageUrl: String
    var imagePath: String?
    var pubDate: Date
    var clickDate: Date?
}
