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
    var endpointParams: String = ""
    
    if (lastTransaction?.count)! > 0 {
        lastTransaction_id = (lastTransaction?[0].identifier)!
        endpointParams = "bitcoinTransactionId=\(lastTransaction_id)"
    }
    
    makeGetRequest(endpointURL: "accounts_info", paramsURL: endpointParams, completion: { completionDictionary in
        
        if let info:NSDictionary = completionDictionary["info"] as? NSDictionary{
            if info.value(forKeyPath: "bitcoinBalance") != nil && info.value(forKeyPath: "bitcoinTransactions") != nil{
                let amountNumber:Float = info.value(forKey: "bitcoinBalance") as! Float
                
                let formatterBTC = NumberFormatter()
                formatterBTC.numberStyle = .currencyAccounting
                formatterBTC.currencyCode = "BTC"
                formatterBTC.currencySymbol = "₿ "
                formatterBTC.minimumFractionDigits = 2
                formatterBTC.maximumFractionDigits = 2
                formatterBTC.groupingSeparator = ","
                formatterBTC.locale = Locale(identifier: "GBP")
                
                let formatterBits = NumberFormatter()
                formatterBits.numberStyle = .currencyAccounting
                formatterBits.currencyCode = "BTC"
                formatterBits.currencySymbol = "μ₿ "
                formatterBits.minimumFractionDigits = 2
                formatterBits.maximumFractionDigits = 2
                formatterBits.groupingSeparator = ","
                formatterBits.locale = Locale(identifier: "GBP")
                
                var balanceAmount: String = ""
                balanceAmount = formatterBits.string(from: NSNumber(value: amountNumber))!

                if let transactions = ((info["bitcoinTransactions"] as? NSDictionary)!["content"]) as? NSArray{
                    for transaction in transactions{
                        
                        var date:Date?
                        
                        if let date_json = (transaction as AnyObject).value(forKeyPath: "createdAt") {
                            let date_text:String = (date_json as AnyObject).value(forKeyPath: "date") as! String
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
                            date = dateFormatter.date(from: date_text)!
                        }
                        
                        print("amount transaction: \((transaction as AnyObject).value(forKeyPath: "amount")as! NSString)")
                        
                        print(((transaction as AnyObject).value(forKeyPath: "amount") as! NSString).doubleValue)
                        
                        let amountNumber = (transaction as AnyObject).value(forKeyPath: "amount") as! NSString
                        
                        var balanceAmountTransaction: String = ""
                        if abs(amountNumber.doubleValue) >= Double(1000000){
                            let amountBTC: Float = Float(amountNumber.doubleValue.getBTCFromBits())
                            balanceAmountTransaction = formatterBTC.string(from: NSNumber(value: amountBTC))!
                        }else{
                            balanceAmountTransaction = formatterBits.string(from: NSNumber(value: amountNumber.doubleValue))!
                        }
                        
                        var title:String = ""
                        
                        if let payer = (transaction as AnyObject).value(forKeyPath: "payer") as? Int64{
                             title = "Transaction to"
                        }else if let beneficiary = (transaction as AnyObject).value(forKeyPath: "beneficiary") as? Int64{
                             title = "Transaction in your favor"
                        }

                        let subtitle: String = ((transaction as AnyObject).value(forKeyPath: "subject") as? String)!
                        
                        let transactionDictionary = [
                            "id" : (transaction as AnyObject).value(forKeyPath: "id")!,
                            "title": title.removingPercentEncoding!,
                            "subtitle": subtitle.removingPercentEncoding!,
                            "amount": balanceAmountTransaction,
                            "datetime": date!,
                            ]  as [String : Any]
                        
                        BitcoinTransaction.manage(transactionDictionary: transactionDictionary as NSDictionary)
                    }
                }
                    completion(["status":true, "balance": balanceAmount] as NSDictionary)
            }
        } else if let errorMessage = completionDictionary["errorMessage"] {
            completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
        } else {
        completion(["status":false] as NSDictionary)
        }
    })
}
