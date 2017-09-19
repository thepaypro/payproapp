//
//  CountryPrefixLocalConnection.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 26/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

extension Country{
    class func loadLocalCountriesPrefixes() -> [Country]{
        var countries:[Country] = []
        do{
            if let file = Bundle.main.url(forResource: "countries-prefixes", withExtension: "json"){
                let data = try Data(contentsOf: file)
                if let jsonDataArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    for eachData in jsonDataArray!{
                        if let object = Country(json: eachData){
                            countries.append(object)
                        }else{
                            print("JSON is invalid")
                            return []
                        }
                    }
                }
            }
        }
        catch{
            print(error.localizedDescription)
        }
        return countries
    }    
}
