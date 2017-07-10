//
//  ContactCell.swift
//  thepayproapp
//
//  Created by Enric Giribet Usó on 17/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var contactTextLabel: UILabel!
    @IBOutlet weak var contactDetailTextLabel: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactInitialLabel: UILabel!
    @IBOutlet weak var contactContainerView: UIView!
    @IBOutlet weak var imagePayProUser: UIImageView! {
        didSet{
            imagePayProUser.clipsToBounds = true
            imagePayProUser.layer.cornerRadius = imagePayProUser.frame.size.width / 2;
        }
    }
    
    var contact: Contact?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        selectionStyle = UITableViewCellSelectionStyle.none
        contactContainerView.layer.masksToBounds = true
        contactContainerView.layer.cornerRadius = contactContainerView.frame.size.width/2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateInitialsColorForIndexPath(_ indexpath: IndexPath) {
        //Applies color to Initial Label
        let colorArray = [GlobalConstants.Colors.amethystColor,GlobalConstants.Colors.asbestosColor, GlobalConstants.Colors.emeraldColor,GlobalConstants.Colors.peterRiverColor,GlobalConstants.Colors.pomegranateColor,GlobalConstants.Colors.pumpkinColor,GlobalConstants.Colors.sunflowerColor]
        let randomValue = (indexpath.row + indexpath.section) % colorArray.count
        contactInitialLabel.backgroundColor = colorArray[randomValue]
    }
    
    func updateContactsinUI(_ contact: Contact, validateContacts: NSDictionary, indexPath: IndexPath, subtitleType: SubtitleCellValue) {
        self.contact = contact
        
        //Update all UI in the cell here
        self.contactTextLabel?.text = contact.displayName()
        updateSubtitleBasedonType(subtitleType, contact: contact)
        
        if contact.thumbnailProfileImage != nil {
            self.contactImageView?.image = contact.thumbnailProfileImage
            self.contactImageView.isHidden = false
            self.contactInitialLabel.isHidden = true
        } else {
            self.contactInitialLabel.text = contact.contactInitials()
            updateInitialsColorForIndexPath(indexPath)
            self.contactImageView.isHidden = true
            self.contactInitialLabel.isHidden = false
        }
        
        //Check if contact is an PayPro user
        let phoneNumbers = self.contact?.phoneNumbers.count as! Int
        
        if phoneNumbers > 0 {
            let phoneNumber:String = (self.contact?.phoneNumbers[0].phoneNumber)!
            
            if let validateContactRow = validateContacts.value(forKeyPath: phoneNumber) {
            
                let isPayProUser = (validateContactRow as AnyObject).value(forKeyPath: "isUser") as! String
            
                if isPayProUser == "true" {
                    contact.setIsPayProUser(value: true)
                
                    let beneficiaryName = (validateContactRow as AnyObject).value(forKeyPath: "fullName") as! String
                    contact.setBeneficiaryName(beneficiaryNameValue: beneficiaryName)
                
                    self.imagePayProUser.isHidden = false
                } else {
                    contact.setIsPayProUser(value: false)
                    self.imagePayProUser.isHidden = true
                }
            } else {
                contact.setIsPayProUser(value: false)
                self.imagePayProUser.isHidden = true
            }
        } else {
            contact.setIsPayProUser(value: false)
            self.imagePayProUser.isHidden = true
        }
    }

    func updateSubtitleBasedonType(_ subtitleType: SubtitleCellValue , contact: Contact) {
        
//        switch subtitleType {
//            
//        case SubtitleCellValue.phoneNumber:
        if subtitleType == SubtitleCellValue.phoneNumber {
            let phoneNumberCount = contact.phoneNumbers.count
            
            if phoneNumberCount == 1  {
                self.contactDetailTextLabel.text = "\(contact.phoneNumbers[0].phoneNumber)"
            }
            else if phoneNumberCount > 1 {
                self.contactDetailTextLabel.text = "\(contact.phoneNumbers[0].phoneNumber) and \(contact.phoneNumbers.count-1) more"
            }
            else {
                self.contactDetailTextLabel.text = GlobalConstants.Strings.phoneNumberNotAvaialable
            }
        }
//        case SubtitleCellValue.email:
////            let emailCount = contact.emails.count
////            
////            if emailCount == 1  {
////                self.contactDetailTextLabel.text = "\(contact.emails[0].email)"
////            }
////            else if emailCount > 1 {
////                self.contactDetailTextLabel.text = "\(contact.emails[0].email) and \(contact.emails.count-1) more"
////            }
////            else {
////                self.contactDetailTextLabel.text = GlobalConstants.Strings.emailNotAvaialable
////            }
//        case SubtitleCellValue.birthday:
////            self.contactDetailTextLabel.text = contact.birthdayString
//        case SubtitleCellValue.organization:
////            self.contactDetailTextLabel.text = contact.company
//        }
    }
}

