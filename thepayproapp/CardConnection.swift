//
//  CardConnection.swift
//  thepayproapp
//
//  Created by Enric Giribet Usó on 1/8/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation

func CardConnection(completion: @escaping (_ cardResponse: NSDictionary) -> Void)
{

    makePostRequest(paramsDictionary: [:] as NSDictionary, endpointURL: "cards/request", completion: {completionDictionary in
        
        print("completionDictionary: \(completionDictionary)")
        
        User.currentUser()?.cardStatus = User.CardStatus.ordered
        
        completion(["status": true] as NSDictionary)
        
//        if completionDictionary["transaction"] != nil {
//            completion(["status": registerTransaction != nil] as NSDictionary)
//        } else if let errorMessage = completionDictionary["errorMessage"] {
//            completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
//        } else {
//            completion(["status": false] as NSDictionary)
//        }
    })
}

func CardActivation(completion: @escaping (_ cardResponse: NSDictionary) -> Void)
{
    makePostRequest(paramsDictionary: [:] as NSDictionary, endpointURL: "cards/activation", completion: {completionDictionary in
        
        print("completionDictionary: \(completionDictionary)")
        
        User.currentUser()?.cardStatus = User.CardStatus.activated
        
        completion(["status": true] as NSDictionary)
    })
}

func CardUpdateStatus(status: Bool, completion: @escaping (_ cardResponse: NSDictionary) -> Void)
{
    let accountId:Int64 = Int64((User.currentUser()?.identifier)!)
    
    print("status: \(status)")
    
    makePostRequest(paramsDictionary: ["enabled":status] as NSDictionary, endpointURL: "cards/\(accountId)", completion: {completionDictionary in
        
        print("completionDictionary: \(completionDictionary)")
        
        if status == true {
            User.currentUser()?.cardStatus = User.CardStatus.activated
        } else if status == false {
            User.currentUser()?.cardStatus = User.CardStatus.disabled
        }
        
        completion(["status": true] as NSDictionary)
    })
}

