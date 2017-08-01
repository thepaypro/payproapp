//
//  Contact.swift
//  thepayproapp
//
//  Created by Enric Giribet Usó on 17/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit
import Contacts

open class Contact {
    
    open var firstName: String
    open var lastName: String
//    open var company: String
    open var thumbnailProfileImage: UIImage?
    open var profileImage: UIImage?
//    open var birthday: Date?
//    open var birthdayString: String?
    open var contactId: Int?
    open var phoneNumbers = [(phoneNumber: String, phoneLabel: String)]()
//    open var emails = [(email: String, emailLabel: String )]()
    open var isPayProUser: Bool = false
    open var beneficiaryName: String?
    open var phoneNumber: String?
    
    public init (contact: CNContact) {
        firstName = contact.givenName
        lastName = contact.familyName
//        company = contact.organizationName
//        contactId = contact.identifier
        
        if let thumbnailImageData = contact.thumbnailImageData {
            thumbnailProfileImage = UIImage(data:thumbnailImageData)
        }
        
        if let imageData = contact.imageData {
            profileImage = UIImage(data:imageData)
        }
        
//        if let birthdayDate = contact.birthday {
//            
//            birthday = Calendar(identifier: Calendar.Identifier.gregorian).date(from: birthdayDate)
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = GlobalConstants.Strings.birdtdayDateFormat
//            //Example Date Formats:  Oct 4, Sep 18, Mar 9
//            birthdayString = dateFormatter.string(from: birthday!)
//        }
        
        for phoneNumber in contact.phoneNumbers {
            var phoneLabel = "phone"
            if let label = phoneNumber.label {
                phoneLabel = label
            }
            let phone = phoneNumber.value.stringValue
            
            phoneNumbers.append((phone,phoneLabel))
        }
        
//        for emailAddress in contact.emailAddresses {
//            guard let emailLabel = emailAddress.label else { continue }
//            let email = emailAddress.value as String
//            
//            emails.append((email,emailLabel))
//        }
    }
    
    open func displayName() -> String {
        return firstName + " " + lastName
    }
    
    open func contactInitials() -> String {
        var initials = String()
        
        if let firstNameFirstChar = firstName.characters.first {
            initials.append(firstNameFirstChar)
        }
        
        if let lastNameFirstChar = lastName.characters.first {
            initials.append(lastNameFirstChar)
        }
        
        return initials
    }
    
    open func setIsPayProUser(value: Bool){
        isPayProUser = value
    }
    
    open func getIsPayProUser() -> Bool {
        return isPayProUser
    }
    
    open func setBeneficiaryName(beneficiaryNameValue: String) {
        beneficiaryName = beneficiaryNameValue
    }
    
    open func getBeneficiaryName() -> String {
        return beneficiaryName!
    }
    
    open func setPhoneNumber(phoneNumberValue: String) {
        phoneNumber = phoneNumberValue
    }
    
    open func getPhoneNumber() -> String {
        return phoneNumber!
    }
    
    open func setContactId(contactIdValue: Int) {
        contactId = contactIdValue
    }
    
    open func getContactId() -> Int {
        return contactId!
    }
}

