//
//  Constant.swift
//  thepayproapp
//
//  Created by Enric Giribet Usó on 17/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

//Declare all the static constants here
struct GlobalConstants {
    
    //MARK: String Constants
    struct Strings {
        static let birdtdayDateFormat = "MMM d"
        static let contactsTitle = "Contacts"
        static let phoneNumberNotAvaialable = "No phone numbers available"
        static let emailNotAvaialable = "No emails available"
        static let bundleIdentifier = "ContactsPicker"
        static let cellNibIdentifier = "ContactCell"
    }
    
    //MARK: Color Constants
    struct Colors {
        static let emeraldColor = UIColor(red: (46/255), green: (204/255), blue: (113/255), alpha: 1.0)
        static let sunflowerColor = UIColor(red: (241/255), green: (196/255), blue: (15/255), alpha: 1.0)
        static let pumpkinColor = UIColor(red: (211/255), green: (84/255), blue: (0/255), alpha: 1.0)
        static let asbestosColor = UIColor(red: (127/255), green: (140/255), blue: (141/255), alpha: 1.0)
        static let amethystColor = UIColor(red: (155/255), green: (89/255), blue: (182/255), alpha: 1.0)
        static let peterRiverColor = UIColor(red: (52/255), green: (152/255), blue: (219/255), alpha: 1.0)
        static let pomegranateColor = UIColor(red: (192/255), green: (57/255), blue: (43/255), alpha: 1.0)
    }
    
    
    //MARK: Array Constants
    struct Arrays {
        static let alphabets = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"] //# indicates the names with numbers and blank spaces
    }
    
}

