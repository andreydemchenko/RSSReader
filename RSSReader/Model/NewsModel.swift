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
    var pubDate: Date
    var clickDate: Date?
}

//struct ImageDataNews {
//    var url: String
//    var length: String
//    var type: String
//}