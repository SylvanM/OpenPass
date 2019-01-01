//
//  Account+CoreDataProperties.swift
//  OpenPass
//
//  Created by Sylvan Martin on 1/1/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var email: NSData?
    @NSManaged public var name: String?
    @NSManaged public var password: NSData?
    @NSManaged public var username: NSData?
    @NSManaged public var shouldEncrypt: Bool

}
