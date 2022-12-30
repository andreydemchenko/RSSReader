//
//  CoreDataManager.swift
//  RSSReader
//
//  Created by zuzex-62 on 30.12.2022.
//

import Foundation
import CoreData

class CoreDataManager {
    
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
      
      func saveContext() {
          if context.hasChanges {
              do {
                  try context.save()
              } catch {
                  let nserror = error as NSError
                  fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
              }
          }
      }
    func fetchItems() -> [NewsModel] {
        var items = [NewsModel]()
        do {
            var historyItems = [HistoryItem]()
            historyItems = try context.fetch(HistoryItem.fetchRequest())
            items = historyItems.map { item in
                NewsModel(id: item.id ?? "", title: item.title ?? "", link: item.link ?? "", description: item.desc ?? "", imageUrl: item.imageUrl ?? "", pubDate: item.pubDate ?? Date(), clickDate: item.clickDate)
            }
        } catch {
            print("An error occurred with fetching reminders")
        }
        
        return items
    }
        
    func addItem(item: NewsModel) {
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
