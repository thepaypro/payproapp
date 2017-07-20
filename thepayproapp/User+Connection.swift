//
//  User+Connection.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 19/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//


import Foundation

extension User {
    class func register(username: String, password: String, passwordConfirmation: String, validationCode: String, completion: @escaping (_ success: Bool) -> Void)
    {
        let paramsDictionary = [
            "app_user_registration": [
                "username": username,
                "plainPassword": [
                    "first": password,
                    "second": passwordConfirmation
                ],
                "mobileVerificationCode": validationCode
            ]
        ] as [String : Any]
        
        print(paramsDictionary)
        
        makePostRequest(paramsDictionary: paramsDictionary as NSDictionary, endpointURL: "register/", completion: {completionDictionary in
            if let userDictionary = completionDictionary["user"]
            {
                let registeredUser = self.manage(userDictionary: userDictionary as! NSDictionary)
                completion(registeredUser != nil)
            }
        })
    }
    
    class func mobileVerificationCode(phoneNumber: String, completion: @escaping (_ userExistence: Bool) -> Void)
    {
        makePostRequest(paramsDictionary: ["phoneNumber": phoneNumber], endpointURL: "mobile-verification-code", completion: {completionDictionary in
            if let isUser = completionDictionary["isUser"]
            {
                completion(isUser as! Bool)
            }
        });
    }
    
    class func login(username: String, password: String, completion: @escaping (_ success: Bool) -> Void)
    {
        let paramsDictionary = [
            "_username": username,
            "_password": password
            ] as [String : Any]
        
        makePostRequest(paramsDictionary: paramsDictionary as NSDictionary, endpointURL: "login_check", completion: {completionDictionary in
            if let userDictionary = completionDictionary["user"]
            {
                let loggedUser = self.manage(userDictionary: userDictionary as! NSDictionary)
                completion(loggedUser != nil)
            }
        })
    }
    
    class func accountCreate(agreement: String, forename: String, lastname: String, dob: String, documentType: String,  documentFront: String, documentBack: String, completion: @escaping (_ success: Bool) -> Void)
    {
        let user = User.currentUser()
        
        let paramsDictionary = [
            "agreement": user?.accountType,
            "forename": user?.forename,
            "lastname": user?.lastname,
            "birthDate": user?.dob,
            "documentType": user?.documentType,
            "street": user?.street,
            "buildingNumber": user?.buildingNumber,
            "postcode": user?.postCode,
            "city": user?.city,
            "country": user?.country,
            "documentPicture1": documentFront,
            "documentPicture2": documentBack
        ] as [String : Any]
        
        makePostRequest(paramsDictionary: paramsDictionary as NSDictionary, endpointURL: "account-requests", completion: {completionDictionary in
            if completionDictionary["emailSended"] as! Bool == true {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
}
