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
        let accountTypeId: Int32? = attributesDictionary.object(forKey: "account_type_id") as? Int32
        let cardStatusId: Int32? = attributesDictionary.object(forKey: "card_status_id") as? Int32
        let cardHolderId: Int64? = attributesDictionary.object(forKey: "card_holder_id") as? Int64
        let dob: String? = attributesDictionary.object(forKey: "dob") as? String
        let documentNumber: String? = attributesDictionary.object(forKey: "document_number") as? String
        let documentType: String? = attributesDictionary.object(forKey: "document_type") as? String
        let forename: String? = attributesDictionary.object(forKey: "forename") as? String
        let identifier: Int64? = attributesDictionary.object(forKey: "id") as? Int64
        let lastname: String? = attributesDictionary.object(forKey: "lastname") as? String
        let username: String? = attributesDictionary.object(forKey: "username") as? String
        let token: String? = attributesDictionary.object(forKey: "token") as? String
        let status: Int32? = attributesDictionary.object(forKey: "status") as? Int32
        let street: String? = attributesDictionary.object(forKey: "street") as? String
        let buildingNumber: String? = attributesDictionary.object(forKey: "buildingNumber") as? String
        let postcode: String? = attributesDictionary.object(forKey: "postcode") as? String
        let city: String? = attributesDictionary.object(forKey: "city") as? String
        let country: String? = attributesDictionary.object(forKey: "country") as? String
        let countryName: String? = attributesDictionary.object(forKey: "countryName") as? String
        let accountNumber: String? = attributesDictionary.object(forKey: "accountNumber") as? String
        let sortCode: String? = attributesDictionary.object(forKey: "sortCode") as? String
        let email: String? = attributesDictionary.object(forKey: "email") as? String
        let amountBalance: String? = attributesDictionary.object(forKey: "amountBalance") as? String
        let bitcoinAmountBalance: String? = attributesDictionary.object(forKey: "bitcoinAmountBalance") as? String
        let bitcoinAddress: String? = attributesDictionary.object(forKey: "bitcoinAddress") as? String

        
//        var groupMembers: NSSet?
//        var invites: NSSet?
//        var offsetTransactions: NSSet?
//        var transactions: NSSet?
        
        if identifier == nil
        {
            return
        }
        
        // Static account type setting
        // TO-DO: Fetch from WS
//        accountTypeId = 0
        
        if accountTypeId != nil
        {
            user.setValue(accountTypeId, forKeyPath: "accountType")
//            user.accountType = .demoAccount
//            
//            if accountTypeId == 1
//            {
//                user.accountType = .basicAccount
//            }
//            else if accountTypeId == 2
//            {
//                user.accountType = .proAccount
//            }
        }
        
        // Static card status setting
        // TO-DO: Fetch from WS
//        cardStatusId = 1
        
        if cardStatusId != nil
        {
            user.setValue(cardStatusId, forKeyPath: "cardStatus")
//            user.cardStatus = .notOrdered
//            
//            if cardStatusId == 1
//            {
//                user.cardStatus = .ordered
//            }
//            else if cardStatusId == 2
//            {
//                user.cardStatus = .activated
//            }
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
            user.setValue(forename, forKeyPath: "forename")
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
        
        if status != nil
        {
            user.setValue(status, forKeyPath: "status")
        }
        
        if street != nil
        {
            user.setValue(street, forKeyPath: "street")
        }
        
        if buildingNumber != nil
        {
            user.setValue(buildingNumber, forKeyPath: "buildingNumber")
        }
        
        if postcode != nil
        {
            user.setValue(postcode, forKeyPath: "postCode")
        }
        
        if city != nil
        {
            user.setValue(city, forKeyPath: "city")
        }
        
        if country != nil
        {
            user.setValue(country, forKeyPath: "country")
        }
        
        if countryName != nil
        {
            user.setValue(countryName, forKeyPath: "countryName")
        }
        
        if accountNumber != nil
        {
            user.setValue(accountNumber, forKeyPath: "accountNumber")
        }
        
        if sortCode != nil
        {
            user.setValue(sortCode, forKeyPath: "sortCode")
        }
        
        if email != nil
        {
            user.setValue(email, forKeyPath: "email")
        }
        
        if amountBalance != nil
        {
            user.setValue(amountBalance, forKeyPath: "amountBalance")
        }
        
        if bitcoinAmountBalance != nil
        {
            user.setValue(bitcoinAmountBalance, forKeyPath: "bitcoinAmountBalance")
        }
        
        if bitcoinAddress != nil
        {
            user.setValue(bitcoinAddress, forKeyPath: "bitcoinAddress")
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
