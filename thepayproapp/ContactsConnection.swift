//
//  ContactsConnection.swift
//  thepayproapp
//
//  Created by Enric Giribet on 5/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation

func checkContacts(contacts: NSDictionary, completion: @escaping (_ contactsResponse: NSDictionary) -> Void)
{
//    print("contacts: \(contacts)")
    makePostRequest(paramsDictionary: contacts as NSDictionary, endpointURL: "contacts", completion: {contactsDictionary in
        
        //    let callResponse = [
        //        "691 487 998": [
        //            "phonenumber": "+34691487998",
        //            "fullName": "Enric Giribet Usó",
        //            "isUser": "true"
        //        ],
        //        "888-555-5512": [
        //            "phonenumber": "+34 888-555-5512",
        //            "fullName": "John Appleseed López",
        //            "isUser": "true"
        //        ],
        //        "555-610-6679": [
        //            "phonenumber": "+34 555-610-6679",
        //            "fullName": "Homer Simpson",
        //            "isUser": "true"
        //        ]
        //    ] as [String : AnyObject]
        
//        print("response contacts: \(contactsDictionary)")
        
        if contactsDictionary["contacts"] != nil {
            completion(contactsDictionary["contacts"] as! NSDictionary)
        } else {
            completion([:] as NSDictionary)
        }
    })
    
    //    completion(callResponse as NSDictionary)
}
