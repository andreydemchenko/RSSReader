//
//  HistoryItem+CoreDataClass.swift
//  RSSReader
//
//  Created by zuzex-62 on 30.12.2022.
//
//

import Foundation
import CoreData


public class HistoryItem: NSManagedObject {
    
    static func == (lhs: HistoryItem, rhs: HistoryItem) -> Bool {
        return lhs.link == rhs.link && lhs.title == rhs.title && lhs.description == rhs.description
    }

}
