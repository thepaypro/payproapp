//
//  Group+CoreDataProperties.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 15/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var identifier: Int64
    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var groupMembers: NSSet?
    @NSManaged public var invites: NSSet?
    @NSManaged public var offsets: NSSet?
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for groupMembers
extension Group {

    @objc(addGroupMembersObject:)
    @NSManaged public func addToGroupMembers(_ value: GroupMember)

    @objc(removeGroupMembersObject:)
    @NSManaged public func removeFromGroupMembers(_ value: GroupMember)

    @objc(addGroupMembers:)
    @NSManaged public func addToGroupMembers(_ values: NSSet)

    @objc(removeGroupMembers:)
    @NSManaged public func removeFromGroupMembers(_ values: NSSet)

}

// MARK: Generated accessors for invites
extension Group {

    @objc(addInvitesObject:)
    @NSManaged public func addToInvites(_ value: Invite)

    @objc(removeInvitesObject:)
    @NSManaged public func removeFromInvites(_ value: Invite)

    @objc(addInvites:)
    @NSManaged public func addToInvites(_ values: NSSet)

    @objc(removeInvites:)
    @NSManaged public func removeFromInvites(_ values: NSSet)

}

// MARK: Generated accessors for offsets
extension Group {

    @objc(addOffsetsObject:)
    @NSManaged public func addToOffsets(_ value: Offset)

    @objc(removeOffsetsObject:)
    @NSManaged public func removeFromOffsets(_ value: Offset)

    @objc(addOffsets:)
    @NSManaged public func addToOffsets(_ values: NSSet)

    @objc(removeOffsets:)
    @NSManaged public func removeFromOffsets(_ values: NSSet)

}

// MARK: Generated accessors for transactions
extension Group {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
