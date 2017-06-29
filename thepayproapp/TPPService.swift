//
//  TPPService.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 19/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

let TPPAPIURL = "http://34.253.160.180"
let TPPLocalAPIURL = "http://172.28.128.77"

func makePostRequest(paramsDictionary: NSDictionary, endpointURL: String, completion: @escaping (_ json: NSDictionary) -> Void)
{
    let absoluteURL = "\(TPPLocalAPIURL)/\(endpointURL)"
    
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
                DispatchQueue.main.async(execute:
                {
                    if let json = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? NSDictionary
                    {
                        completion(json)
                    }
                    else
                    {
                        print("EMPTY JSON")
                        completion([:])
                    }
                })
            }
        }
        
        task.resume()
    }
}

func makeGetRequest(endpointURL: String, paramsURL: String, completion: @escaping (_ json: NSDictionary) -> Void)
{
    let absoluteURL = "\(TPPLocalAPIURL)/\(endpointURL)/\(paramsURL)"
    
    let request = NSMutableURLRequest(url: URL(string: absoluteURL)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request as URLRequest)
    {
        (data, response, error) -> Void in
        
        if (error != nil)
        {
            print(error!)
        }
        else
        {
            DispatchQueue.main.async(execute:
            {
                if let json = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? NSDictionary
                {
                    completion(json)
                }
                else
                {
                    print("EMPTY JSON")
                    completion([:])
                }
            })
        }
    }
    
    task.resume()
}
