//
//  AccountsConnection.swift
//  thepayproapp
//
//  Created by Roger Baiget on 30/10/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation

func AccountsInfo( completion: @escaping (_ response: NSDictionary) -> Void)
{
    
    var lastTransaction : [BitcoinTransaction]?
    lastTransaction = BitcoinTransaction.getLastTransaction()
    
    var lastTransaction_id:Int64 = 1
    var endpointParams: String = "page=1&size=20"
    
    if (lastTransaction?.count)! > 0 {
        lastTransaction_id = (lastTransaction?[0].identifier)!
        endpointParams = "bitcoinTransactionId=\(lastTransaction_id)"
    }
    
    makeGetRequest(endpointURL: "accounts_info", paramsURL: endpointParams, completion: { completionDictionary in
        
        if let info:NSDictionary = completionDictionary["info"] as? NSDictionary{
            if info.value(forKeyPath: "bitcoinBalance") != nil && info.value(forKeyPath: "bitcoinTransactions") != nil{
                let amountNumber:Float = info.value(forKey: "bitcoinBalance") as! Float
                
                let formatter = NumberFormatter()
                formatter.numberStyle = .currencyAccounting
                formatter.currencyCode = "BTC"
                formatter.currencySymbol = "μ₿"
                formatter.minimumFractionDigits = 2
                formatter.maximumFractionDigits = 2
                formatter.groupingSeparator = ","
                formatter.locale = Locale(identifier: "GBP")
                
                let balanceAmountResult = formatter.string(from: NSNumber(value: amountNumber)) ?? "μ₿ \(amountNumber)"
                
                if let transactions = (info.value(forKeyPath: "bitcoinTransactions") as? NSDictionary)?.value(forKeyPath: "content") {
                    for transaction in transactions as! NSArray{
                        
                        var date:Date?
                        
                        if let date_text = (transaction as AnyObject).value(forKeyPath: "createdAt") as? String{
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S" //Your date format
                            date = dateFormatter.date(from: date_text)! //according to date format your date string
                        }
                        
                        let amountString: Float = ((transaction as AnyObject).value(forKeyPath: "amount") as! NSString).floatValue
                        
                        var title:String = ""
                        
                        if let payer = (transaction as AnyObject).value(forKeyPath: "payer"){
                             title = "Transaction in your favor"
                        }else if let beneficiary = (transaction as AnyObject).value(forKeyPath: "beneficiary"){
                             title = "Transaction to"
                        }

                        let subtitle: String = ((transaction as AnyObject).value(forKeyPath: "subject") as? String)!
                        
                        let transactionDictionary = [
                            "id" : (transaction as AnyObject).value(forKeyPath: "id")!,
                            "title": title.removingPercentEncoding!,
                            "subtitle": subtitle.removingPercentEncoding!,
                            "amount": amountString,
                            "datetime": date ?? Date(),
                            ]  as [String : Any]
                        
                        BitcoinTransaction.manage(transactionDictionary: transactionDictionary as NSDictionary)
                    }
                }
                    completion(["status":true, "balance": balanceAmountResult] as NSDictionary)
            }
        } else if let errorMessage = completionDictionary["errorMessage"] {
            completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
        } else {
        completion(["status":false] as NSDictionary)
        }
    })
}
