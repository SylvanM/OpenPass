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

struct CDHelper {
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save(_ account: Account) {
        
        if let previouslySaved = fetch(account.name!) {
            // record already exists, update it
            
            previouslySaved.setValue(account.username, forKey: "username")
            previouslySaved.setValue(account.password, forKey: "password")
            previouslySaved.setValue(account.email, forKey: "email")
            previouslySaved.setValue(account.group, forKey: "group")
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
            newAccount.setValue(account.group, forKey: "group")
            newAccount.setValue(account.extraData, forKey: "extraData")
            
            do {
                try managedContext.save()
            } catch {
                print("Error on saving: ", error)
            }
        }
        
        
        
    }
    
    // change name of thing
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
    
    // delete account
    func delete(_ account: Account) {
        managedContext.delete(account)
    }
    
    // all different ways of retrieving data
    
    // retrieves ALL saved accounts
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
    
    // retrieves specific Account with a specific name
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
    
    // retrieves all account names
    func fetchNames() -> [String]? {
        
        let accountFetch = Account.accountFetchRequest()
        accountFetch.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        
        do {
            var names: [String] = []
            
            let accounts = try managedContext.fetch(accountFetch) as! [Account]
            
            for i in 0..<accounts.count {
                names.append(accounts[i].name!)
            }
            
            return names
            
        } catch {
            print("Error on fetching: ", error)
        }
        
        return nil
    }
    
    // for GROUPS
    
    
    
    
}
