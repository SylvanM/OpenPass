//
//  CDHelper.swift
//  OpenPass
//
//  Created by Sylvan Martin on 1/1/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Structure helping with all common CoreData operations
struct CDHelper {
    
    /// The context in which all operations will take place
    var managedContext = persistentContainer.viewContext
    
    /**
     Saves an Account object to the CoreDataStack
     
     - Parameters:
     - account: The account to be saved
    */
    func save(_ account: Account) {
        
        if let previouslySaved = fetch(account.name!) {
            // record already exists, update it
            
            previouslySaved.setValue(account.username, forKey: "username")
            previouslySaved.setValue(account.password, forKey: "password")
            previouslySaved.setValue(account.email, forKey: "email")
            previouslySaved.setValue(account.extraData, forKey: "extraData")
            
            do {
                try managedContext.save()
            } catch {
                print("Error on saving: ", error)
            }
            
        } else {
            // record does not already exist, make a new one
            let newAccount = NSManagedObject(entity: account.entity, insertInto: managedContext)
            newAccount.setValue(account.name, forKey: "name")
            newAccount.setValue(account.username, forKey: "username")
            newAccount.setValue(account.password, forKey: "password")
            newAccount.setValue(account.email, forKey: "email")
            newAccount.setValue(account.extraData, forKey: "extraData")
            
            do {
                try managedContext.save()
            } catch {
                print("Error on saving: ", error)
            }
        }
        
        
        
    }
    
    /**
     Changes name of a saved Account
     
     - Parameters:
     - originalName: Name of original object to retrieve and change the name of
     - newName: New name of object
    */
    func changeName(of originalName: String, to newName: String) {
        
        // get original object
        if let account = fetch(originalName) {
            
            // change actual name
            account.setValue(newName, forKey: "name")
            
            // but that's not all. We also must update the key names.
            let keychain = KeychainHelper()
            let originalTag = ("com.OpenPass.keys." + originalName + "key").data(using: .utf8)!
            let newTag = ("com.OpenPass.keys." + newName + "key").data(using: .utf8)!
            
            keychain.changeTag(of: originalTag, to: newTag)
            save(account)
            
        }
        
        // if the condition above is not met, then the original object doesn't exist anyway.
        
    }
    
    /// Deletes a saved account
    func delete(_ account: Account) {
        managedContext.delete(account)
        do {
            try managedContext.save()
        } catch {
            print("Error: \(error)")
        }
    }
    
    /// MARK: Data Retrieval
    
    /// Retrieves all saved accounts
    ///
    /// - Returns: an optional array of Accounts
    func fetch() -> [Account]? {
        
        let accountFetch = Account.accountFetchRequest()
        
        do {
            let accounts = try managedContext.fetch(accountFetch)
            return accounts
        } catch {
            print("Error on fetching: ", error)
        }
        
        return nil
        
    }
    
    /// Retrieves account of specified name
    ///
    /// - Returns: An optional account object. Will be nil if it doesn't exist.
    func fetch(_ name: String) -> Account? {
        
        let accountFetch = Account.accountFetchRequest()
        accountFetch.fetchLimit = 1
        accountFetch.predicate = NSPredicate(format: "name = %@", name)
        
        do {
            let accounts = try managedContext.fetch(accountFetch)
            let retrievedAccount = accounts.first
            return retrievedAccount
        } catch {
            print("Error on fetching: ", error)
        }
        
        return nil
        
    }
    
    /// Retrieves all Accounts
    ///
    /// - Returns: The Account names as an optional string array
    func fetchNames() -> [String]? {
        let sortMethod = UserSettings().get(setting: .sorting) as! UserSettings.SortingType
        
        let accountFetch = Account.accountFetchRequest()
        
        if sortMethod == .alphabetical {
            accountFetch.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        } else if sortMethod == .byDate {
            accountFetch.sortDescriptors = [NSSortDescriptor.init(key: "dateAccessed", ascending: false)]
        }
        
        do {
            var names: [String] = []
            
            let accounts = try managedContext.fetch(accountFetch)
            
            for i in 0..<accounts.count {
                names.append(accounts[i].name!)
            }
            
            return names
            
        } catch {
            print("Error on fetching: ", error)
        }
        
        return nil
    }
    
}
