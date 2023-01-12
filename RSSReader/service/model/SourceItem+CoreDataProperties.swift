//
//  SourceItem+CoreDataProperties.swift
//  RSSReader
//
//  Created by zuzex-62 on 11.01.2023.
//
//

import Foundation
import CoreData


extension SourceItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SourceItem> {
        return NSFetchRequest<SourceItem>(entityName: "SourceItem")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var link: String?

}

extension SourceItem : Identifiable {

}
