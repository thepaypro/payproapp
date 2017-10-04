//
//  BitcoinTransactionConnection.swift
//  thepayproapp
//
//  Created by Roger Baiget on 2/10/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//
import Foundation


func BitcoinTransactionCreate(beneficiary:Int, amount:String, subject:String, completion: @escaping (_ transactionResponse: NSDictionary) -> Void)
{
    let transactionDictionary = [
        "subject": String(subject)!,
        "amount": String(amount)!,
        "beneficiary": String(beneficiary)
        ] as [String : Any]
    
    print("transaction: \(transactionDictionary)")
    makePostRequest(paramsDictionary: transactionDictionary as NSDictionary, endpointURL: "bitcoin-transactions", completion: {completionDictionary in
        
        print("completionDictionary: \(completionDictionary)")
        
        if let transaction = completionDictionary["transaction"] as? NSArray {
            
            var title = "Transaction to "
            title += transaction.value(forKeyPath: "beneficiary") as! String
            
            let subject = transaction.value(forKeyPath: "subject") as! String
            
            let amountNumber: Float = transaction.value(forKeyPath: "amount") as! Float
            
//            var date = Date()
//            
//            if let date_json = (transactionDictionary as AnyObject).value(forKeyPath: "createdAt") {
//                let date_text:String = (date_json as AnyObject).value(forKeyPath: "date") as! String
//                
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
//                
//                date = dateFormatter.date(from: date_text)!
//            }
            
            
            let transactionDictionaryResponse = [
                "id" : transaction.value(forKeyPath: "id")!,
                "title": title.removingPercentEncoding!,
                "subtitle": subject.removingPercentEncoding!,
                "amount": amountNumber,
//                "isPayer": true,
//                "datetime": date
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



func BitcoinTransactionList(page: Int ,completion: @escaping (_ transactionResponse: NSDictionary) -> Void){
    
//    var lastTransaction : [BitcoinTransaction]?
//    lastTransaction = BitcoinTransaction.getLastTransaction()
    
//    var lastTransaction_id:Int64 = 1
    let endpointURL: String = "bitcoin-transactions"
    let endpointParams: String = "page="+String(page)+"&size=5"
    
    //    if (lastTransaction?.count)! > 0 {
    //        lastTransaction_id = (lastTransaction?[0].identifier)!
    //        endpointURL = "transactions/latest"
    //        endpointParams = "transactionId=\(lastTransaction_id)"
    //    }
    
    makeGetRequest(endpointURL: endpointURL, paramsURL: endpointParams, completion: {completionDictionary in
        //        print("completionDictionary: \(completionDictionary)")
        
        if let transactions = completionDictionary["transactions"]{
//            print((transactions as AnyObject).count)
                
//            if (transactions as AnyObject).value(forKeyPath: "response") != nil {
            
//                let content:NSArray = (transactions as AnyObject).value(forKeyPath: "response") as! NSArray
//                let user_id:Int64 = (User.currentUser()?.identifier)!
            if page == 1 {BitcoinTransaction.deleteTransactions()}
                for transaction in transactions as! NSArray{
                    
                    var date:Date?
                    
//                    if let date_json = (transaction as AnyObject).value(forKeyPath: "createdAt") {
//                        let date_text:String = (date_json as AnyObject).value(forKeyPath: "date") as! String
//                        
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S" //Your date format
//                        
//                        date = dateFormatter.date(from: date_text)! //according to date format your date string
//                    }
                    
//                    if let date_text:String = (transaction as AnyObject).value(forKeyPath: "date") as! String{
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S" //Your date format
//                        date = dateFormatter.date(from: date_text)! //according to date format your date string
//                    }
                    
                    if(page == 1){
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S" //Your date format
                        date = dateFormatter.date(from: "528809581.91278797") //according to date format your date string
                    }else{
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S" //Your date format
                        date = dateFormatter.date(from: "528809487.66079497") //according to date format your date string
                    }
                    
                    
            
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
                        "datetime": date ?? "",
                        ]  as [String : Any]
                    
                    BitcoinTransaction.manage(transactionDictionary: transactionDictionary as NSDictionary)
                }
                
                completion(["status": true, "transactionsLoaded": (transactions as AnyObject).count] as NSDictionary)
//            }
        } else if let errorMessage = completionDictionary["errorMessage"] {
            completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
        } else {
            completion(["status": false] as NSDictionary)
        }
    })
}
