//
//  GroupMember+CoreDataProperties.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 15/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation
import CoreData


extension GroupMember {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupMember> {
        return NSFetchRequest<GroupMember>(entityName: "GroupMember")
    }

    @NSManaged public var groupId: Int64
    @NSManaged public var identifier: Int64
    @NSManaged public var isAdmin: Bool
    @NSManaged public var status: String?
    @NSManaged public var userId: Int64
    @NSManaged public var group: Group?
    @NSManaged public var user: User?

}
