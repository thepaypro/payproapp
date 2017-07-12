//
//  User+CoreDataClass.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 20/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(User)
public class User: NSManagedObject
{
    class func create () -> User
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let user : User
        
        if #available(iOS 10.0, *)
        {
            user = User(context: context)
        }
        else
        {
            // Fallback on earlier versions
            user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        }
        
        return user
    }
    
    class func manage (userDictionary: NSDictionary) -> User?
    {
        var user : User?
        
        if let userID = userDictionary.value(forKeyPath: "id")! as? Int64
        {
            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            
            let userFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            userFetchRequest.predicate = NSPredicate(format: "identifier == %d", userID)
            
            do
            {
                user = try context.fetch(userFetchRequest).first as? User
                
                if user == nil
                {
                    user = self.create()
                    user?.identifier = userID
                    self.update(user: user!, attributesDictionary: userDictionary)
                }
                else
                {
                    self.update(user: user!, attributesDictionary: userDictionary)
                }
                
                self.save()
            }
            catch
            {
                fatalError("Failed to fetch user: \(error)")
            }
        }
        
        return user
    }
    
    class func update(user: User, attributesDictionary: NSDictionary)
    {
        let accountTypeId: Int16? = attributesDictionary.object(forKey: "account_type_id") as? Int16
        let cardHolderId: Int64? = attributesDictionary.object(forKey: "card_holder_id") as? Int64
        let dob: NSDate? = attributesDictionary.object(forKey: "dob") as? NSDate
        let documentNumber: String? = attributesDictionary.object(forKey: "document_number") as? String
        let documentType: String? = attributesDictionary.object(forKey: "document_type") as? String
        let forename: String? = attributesDictionary.object(forKey: "forename") as? String
        let identifier: Int64? = attributesDictionary.object(forKey: "id") as? Int64
        let lastname: String? = attributesDictionary.object(forKey: "lastname") as? String
        let username: String? = attributesDictionary.object(forKey: "username") as? String
        let token: String? = attributesDictionary.object(forKey: "token") as? String
        
//        var groupMembers: NSSet?
//        var invites: NSSet?
//        var offsetTransactions: NSSet?
//        var transactions: NSSet?
        
        if identifier == nil
        {
            return
        }
        
        if accountTypeId != nil
        {
            user.setValue(accountTypeId, forKeyPath: "accountTypeId")
        }
        
        if cardHolderId != nil
        {
            user.setValue(cardHolderId, forKeyPath: "cardHolderId")
        }
        
        if dob != nil
        {
            user.setValue(dob, forKeyPath: "dob")
        }
        
        if documentNumber != nil
        {
            user.setValue(documentNumber, forKeyPath: "documentNumber")
        }
        
        if documentType != nil
        {
            user.setValue(documentType, forKeyPath: "documentType")
        }
        
        if forename != nil
        {
            self.setValue(forename, forKeyPath: "forename")
        }
        
        if lastname != nil
        {
            user.setValue(lastname, forKeyPath: "lastname")
        }
        
        if username != nil
        {
            user.setValue(username, forKeyPath: "username")
        }
        
        if token != nil
        {
            user.setValue(token, forKeyPath: "token")
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
    
    class func currentUser() -> User?
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let userFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do
        {
            let users: [User]? = try context.fetch(userFetchRequest) as? [User]
            
            return users!.first
        }
        catch
        {
            fatalError("Failed to fetch user: \(error)")
        }
    }

    class func deleteUser()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
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
