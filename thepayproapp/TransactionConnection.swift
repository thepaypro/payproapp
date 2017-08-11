//
//  TransactionConnection.swift
//  thepayproapp
//
//  Created by Enric Giribet on 31/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation

func TransactionCreate(transaction: NSDictionary, completion: @escaping (_ transactionResponse: NSDictionary) -> Void)
{
    print("transaction: \(transaction)")
    makePostRequest(paramsDictionary: transaction as NSDictionary, endpointURL: "transactions", completion: {completionDictionary in
        
        print("completionDictionary: \(completionDictionary)")
        
        if completionDictionary["transaction"] != nil {
            let date = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            
            let transactionDictionary = completionDictionary["transaction"] as! NSDictionary
            
            let beneficiaryTransaction = transactionDictionary.value(forKeyPath: "beneficiary") as! NSDictionary
            
            var title = "Transaction to "
            title += beneficiaryTransaction.value(forKeyPath: "forename") as! String
            title += " "
            title += beneficiaryTransaction.value(forKeyPath: "lastname") as! String
            
            let subject = transactionDictionary.value(forKeyPath: "subject") as! String
            
            let amountNumber: Float = transactionDictionary.value(forKeyPath: "amount") as! Float
            let amountString: String = String(amountNumber)
            let amountPounds: Float = NSString(string: amountString.getPounds()).floatValue
            
            let transactionDictionaryResponse = [
                "id" : transactionDictionary.value(forKeyPath: "id")!,
                "title": title,
                "subtitle": subject,
                "amount": amountPounds,
                "isPayer": true,
                "datetime": "\(Int(components.year!))/\(Int(components.month!))/\(Int(components.day!)) \(Int(components.hour!)):\(Int(components.minute!))"
            ]  as [String : Any]
            
            let registerTransaction = Transaction.manage(transactionDictionary: transactionDictionaryResponse as NSDictionary)
            
            completion(["status": registerTransaction != nil] as NSDictionary)
        } else if let errorMessage = completionDictionary["errorMessage"] {
            completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
        } else {
            completion(["status": false] as NSDictionary)
        }
    })
}

func TransactionGetTransactions(completion: @escaping (_ transactionsResponse: NSDictionary) -> Void)
{
    var lastTransaction : [Transaction]?
    lastTransaction = Transaction.getLastTransaction()
    
    var lastTransaction_id:Int64 = 1
    
    if (lastTransaction?.count)! > 0 {
        lastTransaction_id = (lastTransaction?[0].identifier)!
    }
    
    print("lastTransaction: \(lastTransaction_id)")
    
    makeGetRequest(endpointURL: "transactions/latest", paramsURL: "transactionId=\(lastTransaction_id)", completion: {completionDictionary in
//        print("completionDictionary: \(completionDictionary)")
        
        if let transactions = completionDictionary["transactions"] {
            
            if (transactions as AnyObject).value(forKeyPath: "content") != nil {
                
                let content:NSArray = (transactions as AnyObject).value(forKeyPath: "content") as! NSArray
                let user_id:Int64 = (User.currentUser()?.identifier)!
                
                for transaction in content {
                    var is_user_payer: Bool = false
                    
                    if let payer = (transaction as AnyObject).value(forKeyPath: "payer") {
                        if let payer_id:Int64 = (payer as AnyObject).value(forKeyPath: "id") as? Int64 {
                            if payer_id == user_id {
                                is_user_payer = true
                            }
                        }
                    }
                    
                    let date = Date()
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                
                    let amountString: String = (transaction as AnyObject).value(forKeyPath: "amount") as! String
                    let amountPounds: Float = NSString(string: amountString.getPounds()).floatValue
                    
                    var title:String = "Transaction in your favor"
                    
                    if let titleFromBack = (transaction as AnyObject).value(forKeyPath: "title") as? String {
                        title = titleFromBack
                        
                    } else if is_user_payer == true {
                        title = "Transaction to"
                        
                        if let beneficiary = (transaction as AnyObject).value(forKeyPath: "beneficiary") {
                            let forename:String = (beneficiary as AnyObject).value(forKeyPath: "forename") as! String
                            title += " "+forename
                            
                            let lastname: String = (beneficiary as AnyObject).value(forKeyPath: "lastname") as! String
                            title += " "+lastname
                        }
                    }

                    let transactionDictionary = [
                        "id" : (transaction as AnyObject).value(forKeyPath: "id")!,
                        "title": title,
                        "subtitle": (transaction as AnyObject).value(forKeyPath: "subject")!,
                        "amount": amountPounds,
                        "isPayer": is_user_payer,
                        "datetime": "\(Int(components.year!))/\(Int(components.month!))/\(Int(components.day!)) \(Int(components.hour!)):\(Int(components.minute!))"
                        ]  as [String : Any]
                
                    Transaction.manage(transactionDictionary: transactionDictionary as NSDictionary)
                }
            }
        }
        completion(["status":true] as NSDictionary)
    })
}
