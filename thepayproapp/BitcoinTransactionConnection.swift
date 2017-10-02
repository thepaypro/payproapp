//
//  BitcoinTransactionConnection.swift
//  thepayproapp
//
//  Created by Roger Baiget on 2/10/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation

func TransactionsList(completion: @escaping (_ transactionResponse: NSDictionary) -> Void){
    
    // var lastTransaction : [BitcoinTransaction]?
    // lastTransaction = BitcoinTransaction.getLastTransaction()
    
    let endpointURL: String = "bitcoin-transactions"
    let endpointParams: String = "page=1&size=20"
    
    makeGetRequest(endpointURL: endpointURL, paramsURL: endpointParams, completion: {completionDictionary in
        
        if completionDictionary["transactions"] != nil {
            completion(["status": true] as NSDictionary)
        } else if let errorMessage = completionDictionary["errorMessage"] {
            completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
        } else {
            completion(["status": false] as NSDictionary)
        }
    })
    
}
