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
