//
//  User+Connection.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 19/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//


import Foundation

func UserUpdate(paramsDictionary: NSDictionary, completion: @escaping (_ userUpdateResponse: NSDictionary) -> Void)
{
    let userId:Int64 = Int64((User.currentUser()?.identifier)!)
    
    makePutRequest(paramsDictionary: paramsDictionary as NSDictionary, endpointURL: "users/\(userId)", completion: {completionDictionary in
        
        print("completionDictionary: \(completionDictionary)")
        
        if completionDictionary["user"] != nil {
            completion(["status":true] as NSDictionary)
        } else {
            completion(["status":false] as NSDictionary)
        }
    })
}

extension User {
    class func register(username: String, password: String, passwordConfirmation: String, validationCode: String, completion: @escaping (_ registerResponse: NSDictionary) -> Void)
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
        
        makePostRequest(paramsDictionary: paramsDictionary as NSDictionary, endpointURL: "register/", completion: {completionDictionary in
            
            if let userDictionary = completionDictionary["user"] as? NSDictionary
            {
                
                var accountDictionary:NSMutableDictionary?
                
                accountDictionary = [
                    "id": userDictionary.value(forKeyPath: "id")!,
                    "username": userDictionary.value(forKeyPath: "username")!,
                    "nickname": userDictionary.value(forKeyPath: "nickname")!
                ];
                
                if let bitcoinAccountInfo = (userDictionary as AnyObject).value(forKeyPath: "bitcoinAccount")! as? NSDictionary {
                    accountDictionary!["bitcoinAddress"] = (bitcoinAccountInfo.value(forKeyPath: "address") as! String)
                }

                AccountsInfo(completion: {response in
                    if let bitcoinBalance = response["balance"], response["status"] as! Bool == true{
                        accountDictionary!["bitcoinAmountBalance"] = bitcoinBalance
                        let loggedUser = self.manage(userDictionary: accountDictionary!)
                        completion(["status":loggedUser != nil] as NSDictionary)
                    }else if let errorMessage = response["errorMessage"] {
                        completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
                        return;
                    }else{
                        completion(["status":false] as NSDictionary)
                        return;
                    }
                });
            } else {
                var errorMessage = completionDictionary["message"] as! String
                if completionDictionary["message"] as! String == "Invalid verification code" {
                    errorMessage = "error_invalid_verification_code"
                } else if completionDictionary["message"] as! String == "Passwords dont match" {
                    errorMessage = "error_passcode_dont_match"
                }
                
                completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
            }
        })
    }
    
    class func mobileVerificationCode(phoneNumber: String, completion: @escaping (_ mobileVerificationResponse: NSDictionary) -> Void)
    {
        makePostRequest(paramsDictionary: ["phoneNumber": phoneNumber], endpointURL: "mobile-verification-code", completion: {completionDictionary in
            if let isUser = completionDictionary["isUser"] {
                completion(["status": true, "isUser": isUser as! Bool] as NSDictionary)
            } else if completionDictionary["errorMessage"] != nil {
                
                var errorMessage = completionDictionary["errorMessage"] as! String
                if completionDictionary["errorMessage"] as! String == "Invalid phone number" {
                    errorMessage = "error_invalid_phonenumber"
                }
                
                completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
                
            } else if completionDictionary["message"] != nil {
                
                var errorMessage = completionDictionary["message"] as! String
                if completionDictionary["message"] as! String == "Invalid phone number" {
                    errorMessage = "error_invalid_phonenumber"
                }
                
                completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
            }
        });
    }
    
    class func login(username: String, password: String, completion: @escaping (_ loginResponse: NSDictionary) -> Void)
    {
        let paramsDictionary = [
            "_username": username,
            "_password": password
            ] as [String : Any]
        
        makePostRequest(paramsDictionary: paramsDictionary as NSDictionary, endpointURL: "login_check", completion: {completionDictionary in
            
            if let userDictionary = completionDictionary["user"] as? NSDictionary{
                
                var loginDictionary:NSMutableDictionary?
                
                loginDictionary = [
                    "id": userDictionary.value(forKeyPath: "id")!,
                    "username": userDictionary.value(forKeyPath: "username")!,
                    "nickname": userDictionary.value(forKeyPath: "nickname")!
                ];
                
                if let bitcoinAccountInfo = (userDictionary as AnyObject).value(forKeyPath: "bitcoinAccount")! as? NSDictionary {
                    loginDictionary!["bitcoinAddress"] = (bitcoinAccountInfo.value(forKeyPath: "address") as! String)
                }
                
                AccountsInfo(completion: {response in
                    if let bitcoinBalance = response["balance"], response["status"] as! Bool == true{
                       loginDictionary!["bitcoinAmountBalance"] = bitcoinBalance
                        let loggedUser = self.manage(userDictionary: loginDictionary!)
                        completion(["status":loggedUser != nil] as NSDictionary)
                    }else if let errorMessage = response["errorMessage"] {
                        completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
                        return;
                    }else{
                        completion(["status":false] as NSDictionary)
                        return;
                    }
                });
            }else{
                completion(["status":false] as NSDictionary)
                return;
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
    
    class func changePasscode(oldPasscode: String, firstPasscode: String, confirmPasscode: String, completion: @escaping (_ changePasscodeResponse: NSDictionary) -> Void)
    {
        let paramsDictionary = [
            "old_password": oldPasscode,
            "new_password": firstPasscode,
            "confirm_password": confirmPasscode
            ] as [String : Any]
        
        let userId:Int64 = Int64((User.currentUser()?.identifier)!)
        
        makePutRequest(paramsDictionary: paramsDictionary as NSDictionary, endpointURL: "users/\(userId)", completion: {completionDictionary in
            if completionDictionary["user"] != nil
            {
                completion(["status":true] as NSDictionary)
            } else {
                completion(["status":false, "messageError": completionDictionary["message"]!] as NSDictionary)
            }
        })
    }
}
