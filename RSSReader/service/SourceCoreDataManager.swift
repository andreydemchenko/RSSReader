//
//  SourceCoreDataManager.swift
//  RSSReader
//
//  Created by zuzex-62 on 11.01.2023.
//

import Foundation
import CoreData

class SourceCoreDataManager {
    
    private lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SourceStorage")
        
        let storeDirectory = NSPersistentContainer.defaultDirectoryURL()
        let url = storeDirectory.appendingPathComponent("SourceStorage.sqlite")
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
    
    private func fetchData() -> [SourceItem] {
        var sourceItems = [SourceItem]()
        do {
            sourceItems = try context.fetch(SourceItem.fetchRequest())
        } catch {
            print("An error occurred with fetching items")
        }
        return sourceItems
    }
    
    func getItems() -> [SourceModel] {
        var items = [SourceModel]()
        var sourceItems = [SourceItem]()
        sourceItems = fetchData()
        items = sourceItems.map { item in
            SourceModel(id: item.id ?? "", link: item.link ?? "", name: item.name ?? "")
        }
        
        return items
    }
    
    func addItem(item: SourceModel) {
        deleteItem(link: item.link)
        
        let sourceItem = SourceItem(context: context)
        sourceItem.id = item.id
        sourceItem.name = item.name
        sourceItem.link = item.link
        saveContext()
    }
    
    func deleteItem(link: String) {
        do {
            let fetchRequest: NSFetchRequest<SourceItem>
            fetchRequest = SourceItem.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(
                format: "link LIKE %@", link
            )
            let objects = try context.fetch(fetchRequest)
            for item in objects {
                context.delete(item)
            }
            
        } catch {
            print("error fetching with predicate")
        }
        saveContext()
    }
    
}
