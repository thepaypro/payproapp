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
            
            let transactionDictionaryResponse = [
                "id" : transactionDictionary.value(forKeyPath: "id")!,
                "title": "Transaction to...",
                "sutitle": transactionDictionary.value(forKeyPath: "subject")!,
                "amount": transactionDictionary.value(forKeyPath: "amount")!,
                "datetime": "\(String(describing: components.year))/\(String(describing: components.month))/\(String(describing: components.day)) \(String(describing: components.hour)):\(String(describing: components.minute))"
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
