//
//  TPPSendMoneyViewController.swift
//  payproapp
//
//  Created by Manuel Ortega Cordovilla on 13/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class TPPSendMoneyViewController: UIViewController, PickerDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let contactPickerScene = ContactsPicker(delegate: self, multiSelection:false, subtitleCellType: SubtitleCellValue.email)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.present(navigationController, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ContactPicker(_: ContactsPicker, didContactFetchFailed error : NSError)
    {
        print("Failed with error \(error.description)")
    }
    
    func ContactPicker(_: ContactsPicker, didSelectContact contact : Contact)
    {
        print("Contact \(contact.displayName()) has been selected")
        
        let alert = UIAlertController(title: "Send money by", message: "", preferredStyle: .actionSheet)
        
        let bankTransfeButtonAction = UIAlertAction(title: "Bank transfer", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            
            self.performSegue(withIdentifier: "bankTransfeSegue", sender: self)
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(bankTransfeButtonAction)
        
        let inviteButtonAction = UIAlertAction(title: "Invite someone to PayPro", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            print("Second Button pressed")
        })
        
        alert.addAction(inviteButtonAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(alert, animated: true, completion: nil)
        
        print("fiiiin")
    }
    
    func ContactPicker(_: ContactsPicker, didCancel error : NSError)
    {
        print("User canceled the selection");
    }
    
    func ContactPicker(_: ContactsPicker, didSelectMultipleContacts contacts: [Contact]) {
        print("The following contacts are selected")
        for contact in contacts {
            print("\(contact.displayName())")
        }
    }

}
