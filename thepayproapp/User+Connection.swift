//
//  User+Connection.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 19/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//


import Foundation
import CoreData

extension User {
    class func register(username: String, password: String, passwordConfirmation: String)
    {
        let paramsDictionary = [
            "app_user_registration": [
                "username": username,
                "plainPassword": [
                    "first": password,
                    "second": passwordConfirmation
                ]
            ]
        ] as [String : Any]
        
        makePostRequest(paramsDictionary: paramsDictionary as NSDictionary, endpointURL: "register", completion: {completionDictionary in
            self.manage(userDictionary: completionDictionary)
        })
    }
    
    class func checkExistence(username: String, completion: @escaping (_ userExistence: Bool) -> Void)
    {
        makeGetRequest(endpointURL: "users/check", paramsURL: username) {completionDictionary in
            completion(completionDictionary.value(forKeyPath: "isUser") as! Bool)
        }
    }
}
