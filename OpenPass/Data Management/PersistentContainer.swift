//
//  PersistentContainer.swift
//  OpenPass
//
//  Created by Sylvan Martin on 2/11/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation
import CoreData

class PersistentContainer: NSPersistentContainer {
    
    override class func defaultDirectoryURL() -> URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.OpenPass")!
    }
    
    override init(name: String, managedObjectModel model: NSManagedObjectModel) {
        super.init(name: name, managedObjectModel: model)
    }
    
}

var persistentContainer: PersistentContainer = {
    let container = PersistentContainer(name: "OpenPass")
    
    container.loadPersistentStores(completionHandler: { (storeDescription: NSPersistentStoreDescription, error: Error?) in
        if let error = error as NSError? {
            fatalError("UnResolved error \(error), \(error.userInfo)")
        }
    })
    
    return container
}()
