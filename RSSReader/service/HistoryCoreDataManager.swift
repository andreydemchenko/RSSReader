//
//  CoreDataManager.swift
//  RSSReader
//
//  Created by zuzex-62 on 30.12.2022.
//

import Foundation
import CoreData

class HistoryCoreDataManager {
    
    private lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HistoryStorage")
        
        let storeDirectory = NSPersistentContainer.defaultDirectoryURL()
        let url = storeDirectory.appendingPathComponent("HistoryStorage.sqlite")
        let description = NSPersistentStoreDescription(url: url)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func fetchData() -> [HistoryItem] {
        var historyItems = [HistoryItem]()
        do {
            historyItems = try context.fetch(HistoryItem.fetchRequest())
        } catch {
            print("An error occurred with fetching items")
        }
        return historyItems
    }
    
    func getItems() -> [NewsModel] {
        var items = [NewsModel]()
        var historyItems = [HistoryItem]()
        historyItems = fetchData()
        items = historyItems.map { item in
            NewsModel(id: item.id ?? "", title: item.title ?? "", link: item.link ?? "", description: item.desc ?? "", imageUrl: item.imageUrl ?? "", pubDate: item.pubDate ?? Date(), clickDate: item.clickDate)
        }
        
        return items
    }
    
    func addItem(item: NewsModel) {
        do {
            let fetchRequest: NSFetchRequest<HistoryItem>
            fetchRequest = HistoryItem.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(
                format: "link LIKE %@", item.link
            )
            let objects = try context.fetch(fetchRequest)
            for item in objects {
                context.delete(item)
            }
            
        } catch {
            print("error fetching with predicate")
        }
        
        let historyItem = HistoryItem(context: context)
        historyItem.id = item.id
        historyItem.title = item.title
        historyItem.link = item.link
        historyItem.desc = item.description
        historyItem.imageUrl = item.imageUrl
        historyItem.clickDate = Date()
        historyItem.pubDate = item.pubDate
        saveContext()
    }
}
