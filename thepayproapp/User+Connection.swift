//
//  User+Connection.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 19/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//


import Foundation

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
                var registeredUser = self.manage(userDictionary: userDictionary )
                
                let accountId:Int64 = Int64((User.currentUser()?.identifier)!)
                
                if registeredUser != nil {
                    let accountDictionary = [
                        "id": accountId,
                        "account_type_id": 0,
                        "card_status_id": 0,
                        "amountBalance": "£ 0.00"
                        ] as [String : Any]
                    
                    registeredUser = self.manage(userDictionary: accountDictionary as NSDictionary)
                }
                
                completion(["status": registeredUser != nil] as NSDictionary)
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
                
                if let gbpAccountInfo = (userDictionary as AnyObject).value(forKeyPath: "gbpAccount")! as? NSDictionary {
                    
                    let statusAccount:String = (gbpAccountInfo.value(forKeyPath: "status") as! String)
                    if statusAccount == "PENDING" {
                        loginDictionary = [
                            "id": userDictionary.value(forKeyPath: "id")!,
                            "username": userDictionary.value(forKeyPath: "username")!,
                            "account_type_id": User.AccountType.demoAccount.rawValue,
                            "status": User.Status.statusActivating.rawValue,
                            "amountBalance": "£ 0.00"
                        ]
                    }else{
//                        guard let cardStatus = (gbpAccountInfo.value(forKeyPath: "card") as? NSDictionary)?.value(forKeyPath: "cardStatus") as? Int else {
//                            let cardstatus = 0
//                        }
                        
                        loginDictionary = [
                            "id": userDictionary.value(forKeyPath: "id")!,
                            "username": userDictionary.value(forKeyPath: "username")!,
                            "forename": gbpAccountInfo.value(forKeyPath: "forename")!,
                            "lastname": gbpAccountInfo.value(forKeyPath: "lastname")!,
                            "dob": gbpAccountInfo.value(forKeyPath: "birthDate")!,
                            "document_type": gbpAccountInfo.value(forKeyPath: "documentType")!,
                            "document_number": gbpAccountInfo.value(forKeyPath: "documentNumber")!,
                            "card_status_id": (gbpAccountInfo.value(forKeyPath: "card") as? NSDictionary)?.value(forKeyPath: "cardStatus") as? Int ?? 0,
                            "accountNumber": gbpAccountInfo.value(forKeyPath: "accountNumber")!,
                            "sortCode": gbpAccountInfo.value(forKeyPath: "sortCode")!,
                            "street": gbpAccountInfo.value(forKeyPath: "street")!,
                            "buildingNumber": gbpAccountInfo.value(forKeyPath: "buildingNumber")!,
                            "postcode": gbpAccountInfo.value(forKeyPath: "postcode")!,
                            "city": gbpAccountInfo.value(forKeyPath: "city")!,
                            "country": gbpAccountInfo.value(forKeyPath: "country")!,
                            "email": gbpAccountInfo.value(forKeyPath: "email")!,
                            "status": User.Status.statusActivated.rawValue
                        ]
                    }
                    completion(["GBPStatus":true] as NSDictionary)
                }else{
                    completion(["GBPStatus":false] as NSDictionary)
                }
                
                if let bitcoinAccountInfo = (userDictionary as AnyObject).value(forKeyPath: "bitcoinAccount")! as? NSDictionary {
                    
                    loginDictionary!["bitcoinAddress"] = bitcoinAccountInfo.value(forKeyPath: "address")!
                    completion(["BitcoinStatus":false] as NSDictionary)
                    
                }else{
                   completion(["BitcoinStatus":false] as NSDictionary)
                }
                
                let accountUser = self.manage(userDictionary: loginDictionary!)
                let loggedUser = self.manage(userDictionary: userDictionary)
                completion(["GBPStatus":loggedUser != nil && accountUser != nil] as NSDictionary)
                
            }else{
                completion(["UserStatus":false] as NSDictionary)
            }
                    
//                    BitcoinGetWallet(completion: {bitcoinWalletResponse in
//
////                        var bitcoinAmountBalance:String? = nil
//                        var bitcoinBalance:String = "μ₿ -.--"
//                        var bitcoinAddr:String? = nil
//
//                        if bitcoinWalletResponse["status"] as! Bool == true {
//                            if bitcoinWalletResponse["balance"] != nil && bitcoinWalletResponse["address"] != nil{
//                                bitcoinAddr = bitcoinWalletResponse["address"] as? String
//                                bitcoinBalance = (bitcoinWalletResponse["balance"] as? String)!
//                            }
//                        }else{
//                            completion(["status":false] as NSDictionary)
//                        }
//
//                        BitcoinTransaction.deleteTransactions()
//                        getBitcoinTransactionsFromBackRequest(page: 1, size: 5, completion: {transactionsResponse in
//                            if (transactionsResponse["status"] as! Bool == false){
//                                completion(["status":false] as NSDictionary)
//                            }
//                        })
//
//                        let statusAccount:String = (accountInformation.value(forKeyPath: "status") as! String)
//
//                        if statusAccount == "PENDING" {
//                            accountDictionary = [
//                                "id": userDictionary.value(forKeyPath: "id")!,
//                                "username": userDictionary.value(forKeyPath: "username")!,
//                                "account_type_id": User.AccountType.demoAccount.rawValue,
//                                "status": User.Status.statusActivating.rawValue,
//                                "amountBalance": "£ 0.00"
//                            ]
//
//                            let accountUser = self.manage(userDictionary: accountDictionary!)
//
//                            let loggedUser = self.manage(userDictionary: userDictionary)
//                            completion(["status":loggedUser != nil && accountUser != nil] as NSDictionary)
//
//                        } else {
//
//                            AccountGetBalance(completion: {accountGetBalanceResponse in
//
//                                var amountBalance = "£ 0.00"
//
//                                if accountGetBalanceResponse["status"] as! Bool == true && accountGetBalanceResponse["balance"] != nil{
//                                    amountBalance = (accountGetBalanceResponse["balance"] as? String)!
//                                }else{
//                                    completion(["status":false] as NSDictionary)
//                                }
//
//                                let agreement = accountInformation.value(forKeyPath: "agreement")
//                                var cardstatus: Int32 = 0
//
//                                if let card: NSDictionary = accountInformation.value(forKeyPath: "card") as? NSDictionary, card.count != 0{
//                                    if card.value(forKeyPath: "isActive") as! Bool == true{
//                                        if card.value(forKeyPath: "isEnabled") as! Bool == true{
//                                            cardstatus = 2
//                                        }else{
//                                            cardstatus = 3
//                                        }
//                                    }else{
//                                        cardstatus = 1
//                                    }
//                                }else{
//                                    cardstatus = 0
//                                }
//
//                                let country = accountInformation.value(forKeyPath: "country")
//
//                                accountDictionary = [
//                                    "id": userDictionary.value(forKeyPath: "id")!,
//                                    "username": userDictionary.value(forKeyPath: "username")!,
//                                    "forename": accountInformation.value(forKeyPath: "forename")!,
//                                    "lastname": accountInformation.value(forKeyPath: "lastname")!,
//                                    "dob": accountInformation.value(forKeyPath: "birthDate")!,
//                                    "document_type": accountInformation.value(forKeyPath: "documentType")!,
//                                    "document_number": accountInformation.value(forKeyPath: "documentNumber")!,
//                                    "account_type_id": (agreement as AnyObject).value(forKeyPath: "id") as! Int32,
//                                    "card_status_id": cardstatus,
//                                    "accountNumber": accountInformation.value(forKeyPath: "accountNumber")!,
//                                    "sortCode": accountInformation.value(forKeyPath: "sortCode")!,
//                                    "street": accountInformation.value(forKeyPath: "street")!,
//                                    "buildingNumber": accountInformation.value(forKeyPath: "buildingNumber")!,
//                                    "postcode": accountInformation.value(forKeyPath: "postcode")!,
//                                    "city": accountInformation.value(forKeyPath: "city")!,
//                                    "country": (country as AnyObject).value(forKeyPath: "iso2")!,
//                                    "countryName": (country as AnyObject).value(forKeyPath: "name")!,
//                                    "email": accountInformation.value(forKeyPath: "email")!,
//                                    "status": User.Status.statusActivated.rawValue,
//                                    "amountBalance": amountBalance,
//                                    "bitcoinAmountBalance": bitcoinBalance,
//                                    "bitcoinAddress": bitcoinAddr ?? ""
//                                ]
//
//                                let accountUser = self.manage(userDictionary: accountDictionary!)
//                                let loggedUser = self.manage(userDictionary: userDictionary)
//
//                                if loggedUser != nil && accountUser != nil {
//                                    Transaction.deleteTransactions()
//                                    getGBPTransactionsFromBackRequest( page: 1, size: 5, completion: {transactionsResponse in
//                                        if (transactionsResponse["status"] as! Bool == false){
//                                            completion(["status":false] as NSDictionary)
//                                        }else{
//                                            completion(["status":loggedUser != nil && accountUser != nil] as NSDictionary)
//                                        }
//                                    })
//                                } else {
//                                    completion(["status":false] as NSDictionary)
//                                }
//                            })
//                        }
//                    })
//                } else {
//                    let status = User.currentUser()?.status.rawValue ?? User.Status.statusDemo.rawValue
//                    accountDictionary = [
//                        "id": userDictionary.value(forKeyPath: "id")!,
//                        "username": userDictionary.value(forKeyPath: "username")!,
//                        "account_type_id": User.AccountType.demoAccount.rawValue,
//                        "status": status
//                    ]
//
//                    let accountUser = self.manage(userDictionary: accountDictionary!)
//
//                    let loggedUser = self.manage(userDictionary: userDictionary)
//                    completion(["status":loggedUser != nil && accountUser != nil] as NSDictionary)
//                }
//
//                //}
//            } else if let errorMessage = completionDictionary["errorMessage"] {
//                completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
//            } else {
//                completion(["status": false] as NSDictionary)
//            }
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
        
        let accountId:Int64 = Int64((User.currentUser()?.identifier)!)
        
        makePutRequest(paramsDictionary: paramsDictionary as NSDictionary, endpointURL: "users/\(accountId)", completion: {completionDictionary in
            if completionDictionary["user"] != nil
            {
                completion(["status":true] as NSDictionary)
            } else {
                completion(["status":false, "messageError": completionDictionary["message"]!] as NSDictionary)
            }
        })
    }
}
