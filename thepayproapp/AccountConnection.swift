//
//  AccountConnection.swift
//  thepayproapp
//
//  Created by Enric Giribet Usó on 1/8/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation

func AccountCreate(
    agreement: Int,
    forename: String,
    lastname: String,
    dob: String,
    documentType: String,
    street: String,
    buildingNumber: String,
    postcode: String,
    city: String,
    country: String,
    documentFront: String,
    documentBack: String,
    deviceToken: String,
    completion: @escaping (_ success: Bool) -> Void)
{
    let paramsDictionary = [
        "agreement": agreement,
        "forename": forename,
        "lastname": lastname,
        "birthDate": dob,
        "documentType": documentType,
        "street": street,
        "buildingNumber": buildingNumber,
        "postcode": postcode,
        "city": city,
        "country": country,
        "documentPicture1": documentFront,
        "documentPicture2": documentBack,
        "deviceToken": deviceToken
        ] as [String : Any]
    
    makePostRequest(paramsDictionary: paramsDictionary as NSDictionary, endpointURL: "account-requests", completion: {completionDictionary in
        print("completionDictionary: \(completionDictionary)")
        if completionDictionary["emailSended"] != nil {
            completion(completionDictionary["emailSended"] as! Bool)
        } else {
            completion(false)
        }
    })
}

func AccountUpdate(paramsDictionary: NSDictionary, completion: @escaping (_ accountUpdateResponse: NSDictionary) -> Void)
{
    let accountId:Int64 = Int64((User.currentUser()?.identifier)!)
    
    print("accountId: \(accountId)")
    
    makePutRequest(paramsDictionary: paramsDictionary as NSDictionary, endpointURL: "accounts/\(accountId)", completion: {completionDictionary in
        
        print("completionDictionary: \(completionDictionary)")
        
        if completionDictionary["account"] != nil {
            completion(["status":true] as NSDictionary)
        } else {
            completion(["status":false] as NSDictionary)
        }
    })
}

func AccountRequestUpdate(paramsDictionary: NSDictionary, completion: @escaping (_ accountUpdateResponse: NSDictionary) -> Void)
{
    makePutRequest(paramsDictionary: paramsDictionary as NSDictionary, endpointURL: "account-requests", completion: {completionDictionary in
        
        print("completionDictionary: \(completionDictionary)")
        
        if completionDictionary["emailSended"] != nil {
            completion(["status":completionDictionary["emailSended"] as! Bool] as NSDictionary)
        } else {
            completion(["status":false] as NSDictionary)
        }
    })
}

func AccountGetBalance(completion: @escaping (_ accountGetBalanceResponse: NSDictionary) -> Void)
{
    makeGetRequest(endpointURL: "balance", paramsURL: "", completion: {
        completionDictionary in
        print("AccountGetBalance completionDictionary: \(completionDictionary)")
        
        if completionDictionary["balance"] != nil {
            let amountNumber:Float = completionDictionary["balance"] as! Float
            let amountString: String = String(amountNumber)
            let balanceAmount: Float = NSString(string: amountString.getPounds()).floatValue
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currencyAccounting
            formatter.currencyCode = "GBP"
            formatter.currencySymbol = "£ "
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            formatter.groupingSeparator = ","
            formatter.locale = Locale(identifier: "GBP")
            
            let balanceAmountResult = formatter.string(from: NSNumber(value: balanceAmount)) ?? "£ \(balanceAmount)"
            
            completion(["status":true, "balance": balanceAmountResult as String] as NSDictionary)
        } else {
            completion(["status":false] as NSDictionary)
        }
    })
}
