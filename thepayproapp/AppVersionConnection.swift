//
//  AppVersionConnection.swift
//  thepayproapp
//
//  Created by Roger Baiget on 13/2/18.
//  Copyright © 2018 The Pay Pro LTD. All rights reserved.
//

import Foundation

func CheckVersion( completion: @escaping (_ response: NSDictionary) -> Void)
{
    let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    makePostRequest(paramsDictionary: ["app_version": version], endpointURL: "app_version/ios", completion: {completionDictionary in
        if let need_update = completionDictionary["need_update"] as? Bool{
            completion(["need_update": need_update] as NSDictionary)
        }else{
            completion(["status": false] as NSDictionary)
        }
        
    })
}
