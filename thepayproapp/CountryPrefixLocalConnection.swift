//
//  CountryPrefixLocalConnection.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 26/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class CountryPrefixLocalConnection: NSObject
{
    class func loadLocalCountriesPrefixes() -> [AnyObject]
    {
        do
        {
            if let file = Bundle.main.url(forResource: "countries-prefixes", withExtension: "json")
            {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                //JSON is an array
                if let object = json as? [AnyObject]
                {
                    return object
                }
                else
                {
                    print("JSON is invalid")
                    
                    return []
                }
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        return []
    }
}
