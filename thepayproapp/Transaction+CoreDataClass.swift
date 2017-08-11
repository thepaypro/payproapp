//
//  Transaction+CoreDataClass.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 15/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Transaction)
public class Transaction: NSManagedObject
{
    class func create () -> Transaction
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let transaction : Transaction
        
        if #available(iOS 10.0, *)
        {
            transaction = Transaction(context: context)
        }
        else
        {
            // Fallback on earlier versions
            transaction = NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: context) as! Transaction
        }
        
        return transaction
    }
    
    class func manage (transactionDictionary: NSDictionary) -> Transaction?
    {
        var transaction : Transaction?
        
        if let transactionID = transactionDictionary.value(forKeyPath: "id")! as? Int64
        {
            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            
            let transactionFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
            transactionFetchRequest.predicate = NSPredicate(format: "identifier == %d", transactionID)
            
            do
            {
                transaction = try context.fetch(transactionFetchRequest).first as? Transaction
                
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
    
    class func update(transaction: Transaction, attributesDictionary: NSDictionary)
    {
        let title: String? = attributesDictionary.object(forKey: "title") as? String
        let subtitle: String? = attributesDictionary.object(forKey: "subtitle") as? String
        let datetime: String? = attributesDictionary.object(forKey: "datetime") as? String
        let identifier: Int64? = attributesDictionary.object(forKey: "id") as? Int64
        let amount: Float? = attributesDictionary.object(forKey: "amount") as? Float
        
        print("amount en manage: \(amount)")
        
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
    
    class func getTransactions() -> [Transaction]?
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let transactionsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        
        let sortDescriptor = NSSortDescriptor(key: "identifier", ascending: false)
        
        transactionsFetchRequest.sortDescriptors = [sortDescriptor]
        
        do
        {
            let transactions: [Transaction]? = try context.fetch(transactionsFetchRequest) as? [Transaction]
            
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
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        
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
                print ("There was an error deleting the user")
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
                print ("There was an error deleting the user")
            }
        }
    }
}
