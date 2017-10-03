//
//  BitcoinTransactionConnection.swift
//  thepayproapp
//
//  Created by Roger Baiget on 2/10/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//
import Foundation

func BitcoinTransactionList(completion: @escaping (_ transactionResponse: NSDictionary) -> Void){
    
    var lastTransaction : [BitcoinTransaction]?
    lastTransaction = BitcoinTransaction.getLastTransaction()
    
    var lastTransaction_id:Int64 = 1
    var endpointURL: String = "bitcoin-transactions"
    var endpointParams: String = "page=1&size=20"
    
    //    if (lastTransaction?.count)! > 0 {
    //        lastTransaction_id = (lastTransaction?[0].identifier)!
    //        endpointURL = "transactions/latest"
    //        endpointParams = "transactionId=\(lastTransaction_id)"
    //    }
    
    makeGetRequest(endpointURL: endpointURL, paramsURL: endpointParams, completion: {completionDictionary in
        //        print("completionDictionary: \(completionDictionary)")
        
        if let transactions = completionDictionary["transactions"]{
            
//            if (transactions as AnyObject).value(forKeyPath: "response") != nil {
            
//                let content:NSArray = (transactions as AnyObject).value(forKeyPath: "response") as! NSArray
//                let user_id:Int64 = (User.currentUser()?.identifier)!
            
                for transaction in transactions as! NSArray{
                    
//                    var date = Date()
                    
//                    if let date_json = (transaction as AnyObject).value(forKeyPath: "createdAt") {
//                        let date_text:String = (date_json as AnyObject).value(forKeyPath: "date") as! String
//                        
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S" //Your date format
//                        
//                        date = dateFormatter.date(from: date_text)! //according to date format your date string
//                    }
                    
                    
                    let amountString: Float = ((transaction as AnyObject).value(forKeyPath: "amount") as! NSString).floatValue
//                    let amountPounds: Float = NSString(string: amountString.getPounds()).floatValue
                    
                    var title:String = "Transaction in your favor"
                    
                    if let titleFromBack = (transaction as AnyObject).value(forKeyPath: "subject") as? String {
                        title = titleFromBack
                    }
//                    else if is_user_payer == true {
//                        title = "Transaction to"
//                        
//                        if let beneficiary = (transaction as AnyObject).value(forKeyPath: "beneficiary")  {
//                            let forename:String = (beneficiary as AnyObject).value(forKeyPath: "forename") as! String
//                            title += " "+forename
//                            
//                            let lastname: String = (beneficiary as AnyObject).value(forKeyPath: "lastname") as! String
//                            title += " "+lastname
//                        }
//                    }
                    
                    let subtitle: String = ((transaction as AnyObject).value(forKeyPath: "beneficiary") as? String)!
                    
                    let transactionDictionary = [
                        "id" : (transaction as AnyObject).value(forKeyPath: "transactionId")!,
                        "title": title.removingPercentEncoding!,
                        "subtitle": subtitle.removingPercentEncoding!,
                        "amount": amountString,
//                        "isPayer": is_user_payer,
//                        "datetime": date,
                        ]  as [String : Any]
                    
                    BitcoinTransaction.manage(transactionDictionary: transactionDictionary as NSDictionary)
                }
                
                completion(["status": true] as NSDictionary)
//            }
        } else if let errorMessage = completionDictionary["errorMessage"] {
            completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
        } else {
            completion(["status": false] as NSDictionary)
        }
    })
}
