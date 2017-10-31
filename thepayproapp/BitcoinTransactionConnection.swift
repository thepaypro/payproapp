//
//  BitcoinTransactionConnection.swift
//  thepayproapp
//
//  Created by Roger Baiget on 2/10/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//
import Foundation


func BitcoinTransactionCreate(addr:String?, beneficiaryUserID: Int?, amount:String, inApp: Bool,  subject:String, completion: @escaping (_ transactionResponse: NSDictionary) -> Void)
{
    var transactionDictionary = [String : Any]()
    if inApp{
        transactionDictionary = [
        "subject": String(subject)!,
        "amount": String(amount)!,
        "beneficiaryUserID" : Int(beneficiaryUserID!),
        ] as [String : Any]
    }else{
        transactionDictionary = [
        "subject": String(subject)!,
        "amount": String(amount)!,
        "beneficiary": String(addr!)!,
        ] as [String : Any]
    }
    
    
    
    makePostRequest(paramsDictionary: transactionDictionary as NSDictionary, endpointURL: "bitcoin-transactions", completion: {completionDictionary in
        
        if let transaction = completionDictionary["transaction"] as? NSDictionary {
            
            var title = "Transaction to "
            title += transaction.value(forKeyPath: "beneficiary") as! String
            
            let subject = transaction.value(forKeyPath: "subject") as! String
            
            let amount: Float = Float(transaction.value(forKeyPath: "amount") as! String)!
            
            var date = Date()
            
            if let date_json = (transactionDictionary as AnyObject).value(forKeyPath: "createdAt") {
                let date_text:String = (date_json as AnyObject).value(forKeyPath: "date") as! String
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
                
                date = dateFormatter.date(from: date_text)!
            }
            
            let transactionDictionaryResponse = [
                "id" : transaction.value(forKeyPath: "transactionId")!,
                "title": title.removingPercentEncoding!,
                "subtitle": subject.removingPercentEncoding!,
                "amount": amount,
                "datetime": date
                ]  as [String : Any]
            
            let registerTransaction = BitcoinTransaction.manage(transactionDictionary: transactionDictionaryResponse as NSDictionary)
            
            completion(["status": registerTransaction != nil] as NSDictionary)
        } else if let errorMessage = completionDictionary["errorMessage"] {
            completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
        } else {
            completion(["status": false] as NSDictionary)
        }
    })
}
