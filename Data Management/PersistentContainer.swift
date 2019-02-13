//
//  PersistentContainer.swift
//  OpenPass
//
//  Created by Sylvan Martin on 2/11/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation
import CoreData

/// A subclass of NSPersistentContainer used for all Targets in the project
class PersistentContainer: NSPersistentContainer {
    
    /// Returns the default directory for the group
    override class func defaultDirectoryURL() -> URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.OpenPass")!
    }
    
    override init(name: String, managedObjectModel model: NSManagedObjectModel) {
        super.init(name: name, managedObjectModel: model)
    }
    
}

/// Global variable for the global persistent container, so that all extensions share the same "database"
var persistentContainer: PersistentContainer = {
    let container = PersistentContainer(name: "OpenPass")
    
    /// Loads saved information from container
    container.loadPersistentStores(completionHandler: { (storeDescription: NSPersistentStoreDescription, error: Error?) in
        if let error = error as NSError? {
            fatalError("UnResolved error \(error), \(error.userInfo)")
        }
    })
    
    return container
}()
