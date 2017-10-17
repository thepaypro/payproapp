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
            
            let transactionDictionaryResponse = [
                "id" : transaction.value(forKeyPath: "transactionId")!,
                "title": title.removingPercentEncoding!,
                "subtitle": subject.removingPercentEncoding!,
                "amount": amount,
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

func getBitcoinTransactionsFromBackRequest(page: Int ,size: Int, completion: @escaping (_ transactionResponse: NSDictionary) -> Void){
    
    makeGetRequest(endpointURL: "bitcoin-transactions", paramsURL: "page="+String(page)+"&size="+String(size), completion: {completionDictionary in
        
        if let transactions = completionDictionary["transactions"]{
            for transaction in transactions as! NSArray{
                
                var date:Date?
                
                if let date_text = (transaction as AnyObject).value(forKeyPath: "createdAt") as? String{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S" //Your date format
                    date = dateFormatter.date(from: date_text)! //according to date format your date string
                }
            
                let amountString: Float = ((transaction as AnyObject).value(forKeyPath: "amount") as! NSString).floatValue
                
                var title:String = "Transaction in your favor"
                
                if let titleFromBack = (transaction as AnyObject).value(forKeyPath: "subject") as? String {
                    title = titleFromBack
                }
                
                let subtitle: String = ((transaction as AnyObject).value(forKeyPath: "beneficiary") as? String)!
                
                let transactionDictionary = [
                    "id" : (transaction as AnyObject).value(forKeyPath: "transactionId")!,
                    "title": title.removingPercentEncoding!,
                    "subtitle": subtitle.removingPercentEncoding!,
                    "amount": amountString,
                    "datetime": date ?? Date(),
                    ]  as [String : Any]
                
                BitcoinTransaction.manage(transactionDictionary: transactionDictionary as NSDictionary)
            }
            completion(["status": true, "newTransactions": (transactions as! NSArray).count] as NSDictionary)
        } else if let errorMessage = completionDictionary["errorMessage"] {
            completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
        } else {
            completion(["status": false] as NSDictionary)
        }
    })
}


