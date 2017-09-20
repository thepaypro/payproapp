//
//  Country.swift
//  thepayproapp
//
//  Created by Roger Baiget on 18/9/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class Country: NSObject {
    let name: String
    let alpha2Code: String
    let callingCodes: String
    var section: Int?
    
    init?(json: [String: Any]){
        self.name = json["name"] as! String
        self.alpha2Code = json["alpha2Code"] as! String
        self.callingCodes = "+" + (json["callingCodes"] as! [String]).first!
    }
    
    init(name: String, alpha2Code: String, callingCodes: String) {
        self.name = name
        self.alpha2Code = alpha2Code
        self.callingCodes = callingCodes
    }
}
