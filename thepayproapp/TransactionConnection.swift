//
//  TransactionConnection.swift
//  thepayproapp
//
//  Created by Roger Baiget on 5/10/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation

var GBPTransactionLoadedPages:Int = 1
var bitcoinTransactionLoadedPages:Int = 1


func getTransactionsFromBack(selectedAccount: PPAccountViewController.AccountCurrencyType, reloadPreviousPage: Bool ,completion: @escaping (_ getTransactionsFromBackResponse: NSDictionary) -> Void)
{
    switch selectedAccount {
    case .bitcoin:
        if reloadPreviousPage {
            getBitcoinTransactionsFromBackRequest(page: bitcoinTransactionLoadedPages , size: 5 ,completion: {transactionsResponse in
                if transactionsResponse["status"] as! Bool == true {
                    completion(["status": true] as NSDictionary)
                    if transactionsResponse["newTransactions"] as! Int == 5 {
                        bitcoinTransactionLoadedPages += 1
                    }
                }else if let errorMessage = transactionsResponse["errorMessage"] {
                    completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
                }else{
                    completion(["status": false] as NSDictionary)
                }
            })
        }else{
            getBitcoinTransactionsFromBackRequest(page: bitcoinTransactionLoadedPages + 1, size: 5 ,completion: {transactionsResponse in
                if transactionsResponse["status"] as! Bool == true {
                    completion(["status": true] as NSDictionary)
                    if transactionsResponse["newTransactions"] as! Int > 0 {
                        bitcoinTransactionLoadedPages += 1
                    }
                }else if let errorMessage = transactionsResponse["errorMessage"] {
                    completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
                }else{
                    completion(["status": false] as NSDictionary)
                }
            })
        }
    }
}

func refreshTransactionsFromBack(selectedAccount: PPAccountViewController.AccountCurrencyType ,completion: @escaping (_ getTransactionsFromBackResponse: NSDictionary) -> Void)
{
    switch selectedAccount {
    case .bitcoin:
        bitcoinTransactionLoadedPages = 1
        BitcoinTransaction.deleteTransactions()
        getBitcoinTransactionsFromBackRequest(page: 1, size: 5 ,completion: {transactionsResponse in
            if transactionsResponse["status"] as! Bool == true {
                completion(["status": true] as NSDictionary)
            }else if let errorMessage = transactionsResponse["errorMessage"] {
                completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
            }else{
                completion(["status": false] as NSDictionary)
            }
        })
    }
}
