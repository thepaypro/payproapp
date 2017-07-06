//
//  ContactsConnection.swift
//  thepayproapp
//
//  Created by Enric Giribet on 5/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import Foundation

func checkContacts(contacts: Array<Any>, completion: @escaping (_ contactsResponse: NSDictionary) -> Void)
{
    let callResponse = [
        "691487998": [
            "phonenumber": "+34691487998",
            "fullName": "Enric Giribet Usó",
            "isUser": "true"
        ],
        "888-555-5512": [
            "phonenumber": "+34 888-555-5512",
            "fullName": "John Appleseed López",
            "isUser": "true"
        ],
        "555-610-6679": [
            "phonenumber": "+34 555-610-6679",
            "fullName": "Homer Simpson",
            "isUser": "true"
        ]
    ] as [String : AnyObject]
    
    completion(callResponse as NSDictionary)
}
