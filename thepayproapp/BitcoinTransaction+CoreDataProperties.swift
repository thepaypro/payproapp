//
//  BitcoinTransaction+CoreDataProperties.swift
//  thepayproapp
//
//  Created by Roger Baiget on 3/10/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation
import CoreData


extension BitcoinTransaction {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BitcoinTransaction> {
        return NSFetchRequest<BitcoinTransaction>(entityName: "BitcoinTransaction")
    }
    
    @NSManaged public var amount: Float
    @NSManaged public var currencyId: Int64
    @NSManaged public var datetime: Date?
    @NSManaged public var groupId: Int64
    @NSManaged public var identifier: String
    @NSManaged public var offsetId: Int64
    @NSManaged public var status: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?
    @NSManaged public var transactionDescription: String?
    @NSManaged public var isPayer: Bool
    @NSManaged public var currency: Currency?
    @NSManaged public var group: Group?
    @NSManaged public var invites: NSSet?
    @NSManaged public var offset: Offset?
    @NSManaged public var user: User?
    
}

// MARK: Generated accessors for invites
extension BitcoinTransaction {
    
    @objc(addInvitesObject:)
    @NSManaged public func addToInvites(_ value: Invite)
    
    @objc(removeInvitesObject:)
    @NSManaged public func removeFromInvites(_ value: Invite)
    
    @objc(addInvites:)
    @NSManaged public func addToInvites(_ values: NSSet)
    
    @objc(removeInvites:)
    @NSManaged public func removeFromInvites(_ values: NSSet)
    
}

