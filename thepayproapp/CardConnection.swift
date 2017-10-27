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
    })
}

func CardRequestActivationCode(completion:  @escaping (_ cardResponse:NSDictionary) -> Void){
    
    makePostRequest(paramsDictionary: [:] as NSDictionary, endpointURL: "cards/requestActivationCode", completion: {completionDictionary in
        
        print("completionDictionary: \(completionDictionary)")
        
        if let success: Bool = completionDictionary["Success"] as? Bool, success{
            completion(["status":true] as NSDictionary)
        } else if let errorMessage = completionDictionary["errorMessage"] {
            completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
        } else {
            completion(["status": false] as NSDictionary)
        }
    })
    
}

func CardActivation(cardActivationCode: String,  PAN: String, completion: @escaping (_ cardResponse: NSDictionary) -> Void)
{
    print("activationCode: \(cardActivationCode)")
    print("cardNum: \(PAN)")
        
    makePostRequest(paramsDictionary: ["cardActivationCode": cardActivationCode, "PAN": PAN] as NSDictionary, endpointURL: "cards/activation", completion: {completionDictionary in
    
        print("completionDictionary: \(completionDictionary)")
        
        if let success: Bool = completionDictionary["Success"] as? Bool, success{
            User.currentUser()?.cardStatus = User.CardStatus.activated
            completion(["status":true] as NSDictionary)
        } else if let errorMessage = completionDictionary["errorMessage"] {
            completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
        } else {
            completion(["status": false] as NSDictionary)
        }
    })
}

func GetPin (CVV2: String, completion: @escaping (_ cardResponse: NSDictionary) -> Void)
{
    makePostRequest(
        paramsDictionary: ["cvv2": CVV2] as NSDictionary,
        endpointURL: "cards/retrive-pin",
        completion: {
            completionDictionary in
                if let currentPin: String = completionDictionary["pin"] as? String {
                    let cleanPin = currentPin.matches(for: "^([0-9]{4})", in: currentPin)
                    if cleanPin.count > 0{
                        completion(["status":true, "pin": cleanPin[0]] as NSDictionary)
                    } else {
                        completion(["status":true, "pin": currentPin] as NSDictionary)
                    }
                } else if let errorMessage = completionDictionary["errorMessage"] {
                    completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
                } else {
                    completion(["status": false] as NSDictionary)
                }
        })
}


func CardUpdateStatus(status: Bool, completion: @escaping (_ cardResponse: NSDictionary) -> Void)
{
    let accountId:Int64 = Int64((User.currentUser()?.identifier)!)
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
