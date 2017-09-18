//
//  TransactionConnection.swift
//  thepayproapp
//
//  Created by Enric Giribet on 31/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation

func TransactionCreate(beneficiary:Int, amount:String, subject:String, title:String, completion: @escaping (_ transactionResponse: NSDictionary) -> Void)
{
    let transactionDictionary = [
        "beneficiary": String(beneficiary),
        "amount": String(amount)!,
        "subject": String(subject)!,
        "title": String(title)!
        ] as [String : Any]
    
    print("transaction: \(transactionDictionary)")
    makePostRequest(paramsDictionary: transactionDictionary as NSDictionary, endpointURL: "transactions", completion: {completionDictionary in
        
        print("completionDictionary: \(completionDictionary)")
        
        if completionDictionary["transaction"] != nil {
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
            
            
            var date = Date()
            
            if let date_json = (transactionDictionary as AnyObject).value(forKeyPath: "createdAt") {
                let date_text:String = (date_json as AnyObject).value(forKeyPath: "date") as! String
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
                
                date = dateFormatter.date(from: date_text)!
            }

            
            let transactionDictionaryResponse = [
                "id" : transactionDictionary.value(forKeyPath: "id")!,
                "title": title.removingPercentEncoding!,
                "subtitle": subject.removingPercentEncoding!,
                "amount": amountPounds,
                "isPayer": true,
                "datetime": date
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
    var endpointURL: String = "transactions"
    var endpointParams: String = "page=1&size=20"
    
    if (lastTransaction?.count)! > 0 {
        lastTransaction_id = (lastTransaction?[0].identifier)!
        endpointURL = "transactions/latest"
        endpointParams = "transactionId=\(lastTransaction_id)"
    }
    
    print("lastTransaction: \(lastTransaction_id)")
    
    makeGetRequest(endpointURL: endpointURL, paramsURL: endpointParams, completion: {completionDictionary in
//        print("completionDictionary: \(completionDictionary)")
        
        if let transactions = completionDictionary["transactions"] {
            
            if (transactions as AnyObject).value(forKeyPath: "content") != nil {
                
                let content:NSArray = (transactions as AnyObject).value(forKeyPath: "content") as! NSArray
                let user_id:Int64 = (User.currentUser()?.identifier)!
                
                for transaction in content {
                    var is_user_payer: Bool = false
                    
                    if let payer = (transaction as AnyObject).value(forKeyPath: "payer") {
                        if let payer_user_id:NSArray = (payer as AnyObject).value(forKeyPath: "users") as? NSArray {
                            
                            if payer_user_id[0] as! Int64 == user_id {
                                is_user_payer = true
                            }
                        }
                    }
                    
                    var date = Date()
                    
                    if let date_json = (transaction as AnyObject).value(forKeyPath: "createdAt") {
                        let date_text:String = (date_json as AnyObject).value(forKeyPath: "date") as! String
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S" //Your date format
                        
                        date = dateFormatter.date(from: date_text)! //according to date format your date string
                    }
                    
                
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
                    
                    let subtitle: String = ((transaction as AnyObject).value(forKeyPath: "subject") as? String)!

                    let transactionDictionary = [
                        "id" : (transaction as AnyObject).value(forKeyPath: "id")!,
                        "title": title.removingPercentEncoding!,
                        "subtitle": subtitle.removingPercentEncoding!,
                        "amount": amountPounds,
                        "isPayer": is_user_payer,
                        "datetime": date
                        ]  as [String : Any]
                
                    Transaction.manage(transactionDictionary: transactionDictionary as NSDictionary)
                }
                
                completion(["status": true] as NSDictionary)
            }
        } else if let errorMessage = completionDictionary["errorMessage"] {
            completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
        } else {
            completion(["status": false] as NSDictionary)
        }
    })
}
