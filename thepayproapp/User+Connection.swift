//
//  User+Connection.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 19/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//


import Foundation

extension User {
    class func register(username: String, password: String, passwordConfirmation: String, validationCode: String)
    {
        let paramsDictionary = [
            "app_user_registration": [
                "username": username,
                "plainPassword": [
                    "first": password,
                    "second": passwordConfirmation
                ],
                "validationCode": validationCode
            ]
        ] as [String : Any]
        
        print(paramsDictionary)
        
        makePostRequest(paramsDictionary: paramsDictionary as NSDictionary, endpointURL: "register/", completion: {completionDictionary in
            self.manage(userDictionary: completionDictionary)
        })
    }
    
    class func mobileVerificationCode(phoneNumber: String, completion: @escaping (_ userExistence: Bool) -> Void)
    {
        makePostRequest(paramsDictionary: ["phoneNumber": phoneNumber], endpointURL: "mobile-verification-code", completion: {completionDictionary in
            completion(completionDictionary.value(forKeyPath: "isUser") as! Bool)
        });
    }
    
    class func login(username: String, password: String, completion: @escaping (_ passwordCorrect: Bool) -> Void)
    {
        let paramsDictionary = [
            "_username": username,
            "_password": password
            ] as [String : Any]
        
        makePostRequest(paramsDictionary: paramsDictionary as NSDictionary, endpointURL: "login_check", completion: {completionDictionary in
            self.manage(userDictionary: completionDictionary)
        })
    }
}
