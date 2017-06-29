//
//  Offset+CoreDataProperties.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 15/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation
import CoreData


extension Offset {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Offset> {
        return NSFetchRequest<Offset>(entityName: "Offset")
    }

    @NSManaged public var groupId: Int64
    @NSManaged public var identifier: Int64
    @NSManaged public var status: String?
    @NSManaged public var group: Group?
    @NSManaged public var offsetTransactions: NSSet?
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for offsetTransactions
extension Offset {

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
extension Offset {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
