//
//  OffsetTransaction+CoreDataProperties.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 15/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation
import CoreData


extension OffsetTransaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OffsetTransaction> {
        return NSFetchRequest<OffsetTransaction>(entityName: "OffsetTransaction")
    }

    @NSManaged public var amount: Float
    @NSManaged public var beneficiaryId: Int64
    @NSManaged public var identifier: Int64
    @NSManaged public var offsetId: Int64
    @NSManaged public var payerId: Int64
    @NSManaged public var status: String?
    @NSManaged public var offset: Offset?
    @NSManaged public var user: User?

}
