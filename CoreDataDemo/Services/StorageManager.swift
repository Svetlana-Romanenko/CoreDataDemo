//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Светлана Романенко on 13.03.2021.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    static let context = shared.persistentContainer.viewContext
    
    // MARK: - Core Data stack
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    static func saveContext() {
        if self.context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
