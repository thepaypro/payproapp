//
//  User+CoreDataProperties.swift
//  thepayproapp
//
//  Created by Enric Giribet Usó on 20/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var identifier: Int64
    @NSManaged public var token: String?
    @NSManaged public var username: String?
    @NSManaged public var supportChatId: Int64
    @NSManaged public var offsetTransactions: NSSet?
    @NSManaged public var transactions: NSSet?
    @NSManaged public var bitcoinAddress: String?
    @NSManaged public var bitcoinAmountBalance: String?
    @NSManaged public var nickname: String?

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
