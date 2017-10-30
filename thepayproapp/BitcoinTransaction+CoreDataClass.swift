//
//  BitcoinTransaction+CoreDataClass.swift
//  thepayproapp
//
//  Created by Roger Baiget on 3/10/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(BitcoinTransaction)
public class BitcoinTransaction: NSManagedObject
{
    class func create () -> BitcoinTransaction
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let transaction : BitcoinTransaction
        
        if #available(iOS 10.0, *)
        {
            transaction = BitcoinTransaction(context: context)
        }
        else
        {
            // Fallback on earlier versions
            transaction = NSEntityDescription.insertNewObject(forEntityName: "BitcoinTransaction", into: context) as! BitcoinTransaction
        }
        
        return transaction
    }
    
    class func manage (transactionDictionary: NSDictionary) -> BitcoinTransaction?
    {
        var transaction : BitcoinTransaction?
        
        if let transactionID = transactionDictionary.value(forKeyPath: "id")! as? Int64
        {
            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            
            let transactionFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitcoinTransaction")
            transactionFetchRequest.predicate = NSPredicate(format: "identifier == %d", transactionID)
            
            do
            {
                transaction = try context.fetch(transactionFetchRequest).first as? BitcoinTransaction
                
                if transaction == nil
                {
                    
                    transaction = self.create()
                    transaction?.identifier = transactionID
                    self.update(transaction: transaction!, attributesDictionary: transactionDictionary)
                }
                else
                {
                    self.update(transaction: transaction!, attributesDictionary: transactionDictionary)
                }
                
                self.save()
            }
            catch
            {
                fatalError("Failed to fetch transaction: \(error)")
            }
        }
        
        return transaction
    }
    
    class func update(transaction: BitcoinTransaction, attributesDictionary: NSDictionary)
    {
        let title: String? = attributesDictionary.object(forKey: "title") as? String
        let subtitle: String? = attributesDictionary.object(forKey: "subtitle") as? String
        let datetime: Date? = attributesDictionary.object(forKey: "datetime") as? Date
        let identifier: Int64? = attributesDictionary.object(forKey: "id") as? Int64
        let amount: Float? = attributesDictionary.object(forKey: "amount") as? Float
        let isPayer: Bool? = attributesDictionary.object(forKey: "isPayer") as? Bool
        
        if identifier == nil
        {
            return
        }
        
        if title != nil
        {
            transaction.title = title
        }
        
        if subtitle != nil
        {
            transaction.subtitle = subtitle
        }
        
        if datetime != nil
        {
            transaction.datetime = datetime
        }
        
        if amount != nil
        {
            transaction.amount = amount!
        }
        
        if isPayer != nil
        {
            transaction.isPayer = isPayer!
        }
    }
    
    class func save()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        do
        {
            try context.save()
        }
        catch let error as NSError
        {
            print("Failure to save context: \(error) \(error.userInfo)")
        }
    }
    
    class func getTransactions() -> [BitcoinTransaction]?
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let transactionsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitcoinTransaction")
        
        let sortDescriptor = NSSortDescriptor(key: "datetime", ascending: false)
        
        transactionsFetchRequest.sortDescriptors = [sortDescriptor]
        
        do
        {
            let transactions: [BitcoinTransaction]? = try context.fetch(transactionsFetchRequest) as? [BitcoinTransaction]

            return transactions!
        }
        catch
        {
            fatalError("Failed to fetch transactions: \(error)")
        }
    }
    
    class func getLastTransaction() -> [BitcoinTransaction]?
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let transactionsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BitcoinTransaction")
        
        let sortDescriptor = NSSortDescriptor(key: "identifier", ascending: false)
        
        transactionsFetchRequest.sortDescriptors = [sortDescriptor]
        
        transactionsFetchRequest.fetchLimit = 1
        
        do
        {
            let transactions: [BitcoinTransaction]? = try context.fetch(transactionsFetchRequest) as? [BitcoinTransaction]
            return transactions!
        }
        catch
        {
            fatalError("Failed to fetch transactions: \(error)")
        }
    }
    
    class func deleteTransactions()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "BitcoinTransaction")
        
        if #available(iOS 9.0, *)
        {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            do
            {
                try context.execute(deleteRequest)
                try context.save()
            }
            catch
            {
                print ("There was an error deleting the bitcoinTransactions")
            }
        }
        else
        {
            // Fallback on earlier versions
            
            deleteFetch.returnsObjectsAsFaults = false
            
            do
            {
                let results = try context.fetch(deleteFetch)
                for managedObject in results
                {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    context.delete(managedObjectData)
                }
            }
            catch
            {
                print ("There was an error deleting the bitcoinTransactions")
            }
        }
    }
}

