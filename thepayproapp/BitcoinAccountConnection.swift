//
//  BitcoinAccountConnection.swift
//  thepayproapp
//
//  Created by Roger Baiget on 2/10/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation

func BitcoinGetWallet(completion: @escaping (_ bitcoinAccountGetWalletResponse: NSDictionary) -> Void)
{
    /*makeGetRequest(endpointURL: "bitcoin-wallets", paramsURL: "", completion: {
        completionDictionary in
        
        if completionDictionary["balance"] != nil {
            let amountNumber:Float = completionDictionary["balance"] as! Float
            let amountString: String = String(amountNumber)
            let balanceAmount: Float = NSString(string: amountString).floatValue
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currencyAccounting
            formatter.currencyCode = "bits"
            formatter.currencySymbol = "μ₿"
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            formatter.groupingSeparator = ","
            formatter.locale = Locale(identifier: "GBP")
            
            let balanceAmountResult = formatter.string(from: NSNumber(value: balanceAmount)) ?? "μ₿ \(balanceAmount)"
            
            completion(["status":true, "balance": balanceAmountResult as String] as NSDictionary)
        } else {
            completion(["status":false] as NSDictionary)
        }
    })*/
     completion(["status":true, "balance": "123.5", "address":"1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2"] as NSDictionary)
}

func BitcoinGetBalance(completion: @escaping (_ bitcoinGetBalanceResponse: NSDictionary) -> Void)
{
    /*makeGetRequest(endpointURL: "bitcoin-wallets", paramsURL: "", completion: {
     completionDictionary in
     
     if completionDictionary["balance"] != nil {
     let amountNumber:Float = completionDictionary["balance"] as! Float
     let amountString: String = String(amountNumber)
     let balanceAmount: Float = NSString(string: amountString).floatValue
     
     let formatter = NumberFormatter()
     formatter.numberStyle = .currencyAccounting
     formatter.currencyCode = "bits"
     formatter.currencySymbol = "μ₿"
     formatter.minimumFractionDigits = 2
     formatter.maximumFractionDigits = 2
     formatter.groupingSeparator = ","
     formatter.locale = Locale(identifier: "GBP")
     
     let balanceAmountResult = formatter.string(from: NSNumber(value: balanceAmount)) ?? "μ₿ \(balanceAmount)"
     
     completion(["status":true, "balance": balanceAmountResult as String] as NSDictionary)
     } else {
     completion(["status":false] as NSDictionary)
     }
     })*/
    completion(["status":true, "balance": "123.5"] as NSDictionary)
}
