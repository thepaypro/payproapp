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
        let identifier: Int64? = attributesDictionary.object(forKey: "id") as? Int64
        let username: String? = attributesDictionary.object(forKey: "username") as? String
        let token: String? = attributesDictionary.object(forKey: "token") as? String
        let status: Int32? = attributesDictionary.object(forKey: "status") as? Int32
        let bitcoinAmountBalance: String? = attributesDictionary.object(forKey: "bitcoinAmountBalance") as? String
        let bitcoinAddress: String? = attributesDictionary.object(forKey: "bitcoinAddress") as? String
        let nickname: String? = attributesDictionary.object(forKey: "nickname") as? String
        
        
        if identifier == nil
        {
            return
        }
        
        if username != nil
        {
            user.setValue(username, forKeyPath: "username")
        }
        
        if token != nil
        {
            user.setValue(token, forKeyPath: "token")
        }
        
        if status != nil
        {
            user.setValue(status, forKeyPath: "status")
        }
        
        if bitcoinAmountBalance != nil
        {
            user.setValue(bitcoinAmountBalance, forKeyPath: "bitcoinAmountBalance")
        }
        
        if bitcoinAddress != nil
        {
            user.setValue(bitcoinAddress, forKeyPath: "bitcoinAddress")
        }
        
        if nickname != nil
        {
            user.setValue(nickname, forKeyPath: "nickname")
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
