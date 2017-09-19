//
//  PPService.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 19/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

//let PPAPIURL = "http://34.253.160.180"
//let PPAPIURL = "http://35.158.218.151"
let PPAPIURL = "http://api.payproapp.net"
//let PPAPIURL = "http://172.28.128.77"
let PPLocalAPIURL = "http://172.28.128.77"

func makePostRequest(paramsDictionary: NSDictionary, endpointURL: String, completion: @escaping (_ json: NSDictionary) -> Void)
{
    if Reachability.isConnectedToNetwork() == true
    {
        let absoluteURL = "\(PPAPIURL)/\(endpointURL)"
        
        if let postData = (try? JSONSerialization.data(withJSONObject: paramsDictionary, options: []))
        {
            let tokenAccess = UserDefaults.standard.string(forKey: "token")
            
            let request = NSMutableURLRequest(url: URL(string: absoluteURL)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if tokenAccess != nil && tokenAccess != "" {
                request.addValue("Bearer "+tokenAccess!, forHTTPHeaderField: "Authorization")
            }
            
            request.httpBody = postData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest)
            {
                (data, response, error) -> Void in
                
                if (error != nil)
                {
                    print(error!)
                    
                    if error?._code ==  NSURLErrorTimedOut {
                        print("Time Out")
                        DispatchQueue.main.async(execute: {
                            completion(["status":false, "message":"internet_connection_timeout", "errorMessage":"internet_connection_timeout"])
                        });
                    }
                }
                else
                {
                    DispatchQueue.main.async(execute:
                        {
                            if let json = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? NSDictionary
                            {
                                if json["token"] != nil {
                                    UserDefaults.standard.setValue(json["token"], forKey: "token")
                                }
                                
                                completion(json)
                            }
                            else
                            {
                                print("EMPTY JSON")
                                completion(["status":false])
                            }
                    })
                }
            }
            
            task.resume()
        }
        
    }
    else
    {
        print("Internet Connection not Available!")
        completion(["status":false, "message":"internet_connection_not_available", "errorMessage":"internet_connection_not_available"])
    }
}

func makeGetRequest(endpointURL: String, paramsURL: String, completion: @escaping (_ json: NSDictionary) -> Void)
{
    if Reachability.isConnectedToNetwork() == true
    {
        var absoluteURL = "\(PPAPIURL)/\(endpointURL)"
        
        if paramsURL != "" {
            absoluteURL += "?\(paramsURL)"
        }
        
        let request = NSMutableURLRequest(url: URL(string: absoluteURL)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let tokenAccess = UserDefaults.standard.string(forKey: "token")
        
        if tokenAccess != nil && tokenAccess != "" {
            request.addValue("Bearer "+tokenAccess!, forHTTPHeaderField: "Authorization")
        }
        
            let task = URLSession.shared.dataTask(with: request as URLRequest)
            {
                (data, response, error) -> Void in
            
                if (error != nil)
                {
                    print(error!)
                    
                    if error?._code ==  NSURLErrorTimedOut {
                        print("Time Out")
                        DispatchQueue.main.async(execute: {
                            completion(["status":false, "message":"internet_connection_timeout", "errorMessage":"internet_connection_timeout"])
                        });
                    }
                }
                else
                {
                    DispatchQueue.main.async(execute:
                        {
                            if let json = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? NSDictionary
                            {
                                if json["token"] != nil {
                                    UserDefaults.standard.setValue(json["token"], forKey: "token")
                                }
                            
                                completion(json)
                            }
                            else
                            {
                                print("EMPTY JSON")
                                completion(["status":false])
                            }
                    })
                }
            }
        
            task.resume()
    }
    else
    {
        print("Internet Connection not Available!")
        completion(["status":false, "message":"internet_connection_not_available", "errorMessage":"internet_connection_not_available"])
    }
}

func makePutRequest(paramsDictionary: NSDictionary, endpointURL: String, completion: @escaping (_ json: NSDictionary) -> Void)
{
    if Reachability.isConnectedToNetwork() == true
    {
        let absoluteURL = "\(PPAPIURL)/\(endpointURL)"
        
        if let postData = (try? JSONSerialization.data(withJSONObject: paramsDictionary, options: []))
        {
            let tokenAccess = UserDefaults.standard.string(forKey: "token")
            
            let request = NSMutableURLRequest(url: URL(string: absoluteURL)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if tokenAccess != nil && tokenAccess != "" {
                request.addValue("Bearer "+tokenAccess!, forHTTPHeaderField: "Authorization")
            }
            
            request.httpBody = postData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest)
            {
                (data, response, error) -> Void in
                
                if (error != nil)
                {
                    print(error!)
                    
                    if error?._code ==  NSURLErrorTimedOut {
                        print("Time Out")
                        DispatchQueue.main.async(execute: {
                            completion(["status":false, "message":"internet_connection_timeout", "errorMessage":"internet_connection_timeout"])
                        });
                    }
                }
                else
                {
                    DispatchQueue.main.async(execute:
                        {
                            if let json = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? NSDictionary
                            {
                                if json["token"] != nil {
                                    UserDefaults.standard.setValue(json["token"], forKey: "token")
                                }
                                
                                completion(json)
                            }
                            else
                            {
                                print("EMPTY JSON")
                                completion(["status":false])
                            }
                    })
                }
            }
            
            task.resume()
        }
    }
    else
    {
        print("Internet Connection not Available!")
        completion(["status":false, "message":"internet_connection_not_available", "errorMessage":"internet_connection_not_available"])
    }
}
