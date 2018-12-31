//
//  Account+CoreDataProperties.swift
//  OpenPass
//
//  Created by Sylvan Martin on 12/31/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//
//

import Foundation
import CoreData

extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var username: String?

}
