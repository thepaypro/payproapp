//
//  ExtensionFloat.swift
//  thepayproapp
//
//  Created by Roger Baiget on 31/10/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

extension Float {
    
    func getBTCFromBits() -> Float{
        let amount = self
        
        let BTC = amount * Float(0.000001)
        
        return Float(BTC)
    }
    
    func getbitsFromBTC() -> Float{
        let amount = self
        
        let BTC = amount / Float(0.000001)
        
        return Float(BTC)
    }
}

