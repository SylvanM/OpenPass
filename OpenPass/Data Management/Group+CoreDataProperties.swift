//
//  Group+CoreDataProperties.swift
//  OpenPass
//
//  Created by Sylvan Martin on 1/5/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func groupFetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var name: String?

}
