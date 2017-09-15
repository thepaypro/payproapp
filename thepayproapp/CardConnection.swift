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
        
        let identified: Int64 = Int64((User.currentUser()?.identifier)!)
        let newStatus: Int32 = Int32(User.CardStatus.ordered.rawValue)
        
        let userDictionary = [
            "id": identified,
            "card_status_id": newStatus
        ] as [String : Any]
        
        let updateCardStatus = User.manage(userDictionary: userDictionary as NSDictionary)
        
        completion(["status": updateCardStatus != nil] as NSDictionary)
        
//        if completionDictionary["transaction"] != nil {
//            completion(["status": registerTransaction != nil] as NSDictionary)
//        } else if let errorMessage = completionDictionary["errorMessage"] {
//            completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
//        } else {
//            completion(["status": false] as NSDictionary)
//        }
    })
}

func CardActivation(cardActivationCode: String,  PAN: String, completion: @escaping (_ cardResponse: NSDictionary) -> Void)
{
    print("activationCode: \(cardActivationCode)")
    print("cardNum: \(PAN)")
    
    //DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
        
        //makePostRequest(paramsDictionary: [:] as NSDictionary, endpointURL: "cards/activation", completion: {completionDictionary in
        
            //print("completionDictionary: \(completionDictionary)")
        
            User.currentUser()?.cardStatus = User.CardStatus.activated
        
            completion(["status": true,"errorMessage": ""] as NSDictionary)
        //})
        
    //})
}

func GetPin (CVV2: String, completion: @escaping (_ cardResponse: NSDictionary) -> Void)
{
    //DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {

        //makePostRequest(paramsDictionary: [:] as NSDictionary, endpointURL: "cards/activation", completion: {completionDictionary in
    
            //print("completionDictionary: \(completionDictionary)")
    
            completion(["status": true,"pin": "4321"] as NSDictionary)
        
        //})
    //})
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

