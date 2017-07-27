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
                var registeredUser = self.manage(userDictionary: userDictionary as! NSDictionary)
                
                if registeredUser != nil {
                    let accountDictionary = [
                        "account_type_id": 0,
                        "card_status_id": 0
                    ]
                    
                    registeredUser = self.manage(userDictionary: accountDictionary as NSDictionary)
                }
                
                completion(registeredUser != nil)
            } else {
                completion(false)
            }
        })
    }
    
    class func mobileVerificationCode(phoneNumber: String, completion: @escaping (_ userExistence: Bool) -> Void)
    {
        makePostRequest(paramsDictionary: ["phoneNumber": phoneNumber], endpointURL: "mobile-verification-code", completion: {completionDictionary in
            if let isUser = completionDictionary["isUser"]
            {
                completion(isUser as! Bool)
            } else {
                completion(false)
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
            if let userDictionary = completionDictionary["user"] as? NSDictionary
            {
                var accountDictionary:NSDictionary?
                
                if let accountInformation = (userDictionary as AnyObject).value(forKeyPath: "account")! as? NSDictionary {
                    
                    let agreement = accountInformation.value(forKeyPath: "agreement")
                    
                    accountDictionary = [
                        "id": userDictionary.value(forKeyPath: "id")!,
                        "username": userDictionary.value(forKeyPath: "username")!,
                        "forename": accountInformation.value(forKeyPath: "forename")!,
                        "lastname": accountInformation.value(forKeyPath: "lastname")!,
                        "dob": accountInformation.value(forKeyPath: "birthDate")!,
                        "document_type": accountInformation.value(forKeyPath: "documentType")!,
                        "account_type_id": (agreement as AnyObject).value(forKeyPath: "id") as! Int32,
                        "accountNumber": accountInformation.value(forKeyPath: "accountNumber")!,
                        "sortCode": accountInformation.value(forKeyPath: "sortCode")!,
                        "street": accountInformation.value(forKeyPath: "street")!,
                        "buildingNumber": accountInformation.value(forKeyPath: "buildingNumber")!,
                        "postcode": accountInformation.value(forKeyPath: "postcode")!,
                        "city": accountInformation.value(forKeyPath: "city")!,
                        "country": accountInformation.value(forKeyPath: "country")!,
                        "email": accountInformation.value(forKeyPath: "email")!,
                        "status": User.Status.statusActivated.rawValue
                    ]
                } else {
                    let status = User.currentUser()?.status.rawValue ?? User.Status.statusDemo.rawValue
                    accountDictionary = [
                        "id": userDictionary.value(forKeyPath: "id")!,
                        "username": userDictionary.value(forKeyPath: "username")!,
                        "account_type_id": User.AccountType.demoAccount.rawValue,
                        "status": status
                    ]
                }
                
                let accountUser = self.manage(userDictionary: accountDictionary!)
                
                let loggedUser = self.manage(userDictionary: userDictionary)
                completion(loggedUser != nil && accountUser != nil)
            } else {
                completion(false)
            }
        })
    }
        
    class func supportChat(languageCode: String, completion: @escaping (_ success: Bool) -> Void)
    {
        let absoluteURL = "https://www.mensaxe.com/v6/chat-sessions"
        
        let paramsDictionary = [
            "language_code": languageCode,
            "contact_id": "576835"
            ] as [String : Any]
        
        if let postData = (try? JSONSerialization.data(withJSONObject: paramsDictionary, options: []))
        {
            let request = NSMutableURLRequest(url: URL(string: absoluteURL)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest)
            {
                (data, response, error) -> Void in
                
                if (error != nil)
                {
                    print(error!)
                }
                else
                {
                    DispatchQueue.main.async(execute: {
                        if let completionDictionary = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? NSDictionary
                        {
                            if let chatSessionId = completionDictionary.value(forKeyPath: "chat_session.id")
                            {
                                let currentUser = User.currentUser()
                                currentUser?.supportChatId = chatSessionId as! Int64
                                User.save()
                                completion(true)
                            }
                            else
                            {
                                completion(false)
                            }
                        }
                    })
                }
            }
            
            task.resume()
        }
    }
    
    class func accountCreate(
        agreement: Int,
        forename: String,
        lastname: String,
        dob: String,
        documentType: String,
        street: String,
        buildingNumber: String,
        postcode: String,
        city: String,
        country: Int,
        documentFront: String,
        documentBack: String,
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
            "documentPicture2": documentBack
        ] as [String : Any]
        
        makePostRequest(paramsDictionary: paramsDictionary as NSDictionary, endpointURL: "account-requests", completion: {completionDictionary in
            print(completionDictionary)
            if completionDictionary["emailSended"] != nil {
                completion(completionDictionary["emailSended"] as! Bool)
            } else {
                completion(false)
            }
        })
    }
}
