//
//  User+CoreDataProperties.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 19/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var accountTypeId: Int16
    @NSManaged public var cardHolderId: Int64
    @NSManaged public var dob: NSDate?
    @NSManaged public var documentNumber: String?
    @NSManaged public var documentType: String?
    @NSManaged public var forename: String?
    @NSManaged public var identifier: Int64
    @NSManaged public var lastname: String?
    @NSManaged public var username: String?
    @NSManaged public var groupMembers: NSSet?
    @NSManaged public var invites: NSSet?
    @NSManaged public var offsetTransactions: NSSet?
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for groupMembers
extension User {

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
extension User {

    @objc(addInvitesObject:)
    @NSManaged public func addToInvites(_ value: Invite)

    @objc(removeInvitesObject:)
    @NSManaged public func removeFromInvites(_ value: Invite)

    @objc(addInvites:)
    @NSManaged public func addToInvites(_ values: NSSet)

    @objc(removeInvites:)
    @NSManaged public func removeFromInvites(_ values: NSSet)

}

// MARK: Generated accessors for offsetTransactions
extension User {

    @objc(addOffsetTransactionsObject:)
    @NSManaged public func addToOffsetTransactions(_ value: OffsetTransaction)

    @objc(removeOffsetTransactionsObject:)
    @NSManaged public func removeFromOffsetTransactions(_ value: OffsetTransaction)

    @objc(addOffsetTransactions:)
    @NSManaged public func addToOffsetTransactions(_ values: NSSet)

    @objc(removeOffsetTransactions:)
    @NSManaged public func removeFromOffsetTransactions(_ values: NSSet)

}

// MARK: Generated accessors for transactions
extension User {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
