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
    makeGetRequest(endpointURL: "bitcoin-wallets", paramsURL: "", completion: { completionDictionary in
        
        if let wallet:NSDictionary = completionDictionary["wallet"] as? NSDictionary{
            if wallet.value(forKeyPath: "balance") != nil && wallet.value(forKeyPath: "address") != nil && wallet.value(forKey: "units") != nil{
                let amountNumber:Float = (wallet.value(forKey: "balance") as! NSString).floatValue
                let unit:String?
                if(wallet.value(forKey: "units") as! String == "bit"){
                    unit = "μ₿ "
                }else if(wallet.value(forKey: "units") as! String == "BTC"){
                    unit = "BTC "
                }else{
                    unit = ""
                }
                
                let formatter = NumberFormatter()
                formatter.numberStyle = .currencyAccounting
                formatter.currencyCode = "BTC"
                formatter.currencySymbol = unit
                formatter.minimumFractionDigits = 2
                formatter.maximumFractionDigits = 2
                formatter.groupingSeparator = ","
                formatter.locale = Locale(identifier: "GBP")

                let balanceAmountResult = formatter.string(from: NSNumber(value: amountNumber)) ?? "μ₿ \(amountNumber)"

                completion(["status":true, "balance": balanceAmountResult, "address": wallet.value(forKey: "address") as! String] as NSDictionary)
            } else {
                completion(["status":false] as NSDictionary)
            }
        }else{
            completion(["status":false] as NSDictionary)
        }
    })
//    completion(["status":true, "balance": "123.5", "address":"1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2"] as NSDictionary)
}
