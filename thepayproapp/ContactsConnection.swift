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
        
        if contactsDictionary["contacts"] != nil {
            completion(["status": true, "contacts": contactsDictionary["contacts"]] as! NSDictionary)
        } else if let errorMessage = contactsDictionary["errorMessage"] {
            completion(["status": false, "errorMessage": errorMessage] as NSDictionary)
        } else {
            completion(["status": false] as NSDictionary)
        }
    })
}
