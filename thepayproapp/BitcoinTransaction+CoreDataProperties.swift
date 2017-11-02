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
    
    @NSManaged public var amount: String
    @NSManaged public var datetime: Date?
    @NSManaged public var identifier: Int64
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?
    @NSManaged public var transactionDescription: String?
    @NSManaged public var isPayer: Bool
    @NSManaged public var invites: NSSet?
    @NSManaged public var user: User?
    
}
