//
//  Account+CoreDataProperties.swift
//  OpenPass
//
//  Created by Sylvan Martin on 1/13/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//
//

import Foundation
import CoreData

/// Extension in which Account properties are defined
extension Account {

    @nonobjc public class func accountFetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }
    
    /// Email associated with account
    @NSManaged public var email: NSData?
    
    /// Any extra information related to the account (e.g. notes, websites, security questions, etc.)
    @NSManaged public var extraData: NSData?
    
    /// Name of account
    @NSManaged public var name: String?
    
    /// Password associated with account
    @NSManaged public var password: NSData?
    
    /// Username associated with account
    @NSManaged public var username: NSData?
    
    /// Last time account was accessed; used for sorting by "recent"
    @NSManaged public var dateAccessed: NSDate?

}
