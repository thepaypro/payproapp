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
