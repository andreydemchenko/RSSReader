//
//  HistoryItem+CoreDataProperties.swift
//  RSSReader
//
//  Created by zuzex-62 on 13.01.2023.
//
//

import Foundation
import CoreData


extension HistoryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryItem> {
        return NSFetchRequest<HistoryItem>(entityName: "HistoryItem")
    }

    @NSManaged public var clickDate: Date?
    @NSManaged public var desc: String?
    @NSManaged public var id: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var link: String?
    @NSManaged public var pubDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var imagePath: String?

}

extension HistoryItem : Identifiable {

}
