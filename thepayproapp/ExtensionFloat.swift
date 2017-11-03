//
//  ExtensionFloat.swift
//  thepayproapp
//
//  Created by Roger Baiget on 31/10/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

extension Double {
    
    func getBTCFromBits() -> Double{
        let amount = self
        
        let BTC = amount * Double(0.000001)
        
        return Double(BTC)
    }
    
    func getbitsFromBTC() -> Double{
        let amount = self
        
        let BTC = amount / Double(0.000001)
        
        return Double(BTC)
    }
}

