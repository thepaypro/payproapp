//
//  Transaction+CoreDataProperties.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 15/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Float
    @NSManaged public var contisId: Int64
    @NSManaged public var currencyId: Int64
    @NSManaged public var groupId: Int64
    @NSManaged public var identifier: Int64
    @NSManaged public var offsetId: Int64
    @NSManaged public var status: String?
    @NSManaged public var transactionDescription: String?
    @NSManaged public var currency: Currency?
    @NSManaged public var group: Group?
    @NSManaged public var invites: NSSet?
    @NSManaged public var offset: Offset?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for invites
extension Transaction {

    @objc(addInvitesObject:)
    @NSManaged public func addToInvites(_ value: Invite)

    @objc(removeInvitesObject:)
    @NSManaged public func removeFromInvites(_ value: Invite)

    @objc(addInvites:)
    @NSManaged public func addToInvites(_ values: NSSet)

    @objc(removeInvites:)
    @NSManaged public func removeFromInvites(_ values: NSSet)

}
