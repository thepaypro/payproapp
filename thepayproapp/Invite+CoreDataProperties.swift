//
//  Invite+CoreDataProperties.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 15/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation
import CoreData


extension Invite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Invite> {
        return NSFetchRequest<Invite>(entityName: "Invite")
    }

    @NSManaged public var fromUserId: Int64
    @NSManaged public var identifier: Int64
    @NSManaged public var phoneNumber: String?
    @NSManaged public var groups: NSSet?
    @NSManaged public var transactions: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for groups
extension Invite {

    @objc(addGroupsObject:)
    @NSManaged public func addToGroups(_ value: Group)

    @objc(removeGroupsObject:)
    @NSManaged public func removeFromGroups(_ value: Group)

    @objc(addGroups:)
    @NSManaged public func addToGroups(_ values: NSSet)

    @objc(removeGroups:)
    @NSManaged public func removeFromGroups(_ values: NSSet)

}

// MARK: Generated accessors for transactions
extension Invite {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
