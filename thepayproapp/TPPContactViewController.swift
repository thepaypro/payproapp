//
//  TPPContactViewController.swift
//  payproapp
//
//  Created by Enric Giribet on 16/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class TPPContactViewController: UIViewController, PickerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contactPickerScene = ContactsPicker(delegate: self, multiSelection:false, subtitleCellType: SubtitleCellValue.email)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.present(navigationController, animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ContactsPicker delegates
    func ContactPicker(_: ContactsPicker, didContactFetchFailed error : NSError)
    {
        print("Failed with error \(error.description)")
    }
    
    func ContactPicker(_: ContactsPicker, didSelectContact contact : Contact)
    {
        print("Contact \(contact.displayName()) has been selected")
        
        
        classControlProcess.fs()
//        
//        self.dismiss(animated: true, completion: {
//            print("finish dismiss view")
//        })
        
//        self.dismiss(animated: true)
//        ShowAlert()
        

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
    
//    func ShowAlert()
//    {
//        print("in alert func")
//        let alert = UIAlertController(title: "",
//                                      message: "",
//                                      preferredStyle: .alert)
//        
//        let titleFont:[String : AnyObject] = [ NSFontAttributeName : UIFont(name: "AmericanTypewriter", size: 18)! ]
//        let messageFont:[String : AnyObject] = [ NSFontAttributeName : UIFont(name: "HelveticaNeue-Thin", size: 14)! ]
//        let attributedTitle = NSMutableAttributedString(string: "Multiple buttons", attributes: titleFont)
//        let attributedMessage = NSMutableAttributedString(string: "Select an Action", attributes: messageFont)
//        alert.setValue(attributedTitle, forKey: "attributedTitle")
//        alert.setValue(attributedMessage, forKey: "attributedMessage")
//        
//        let action1 = UIAlertAction(title: "Action 1", style: .default, handler: { (action) -> Void in
//            print("ACTION 1 selected!")
//        })
//        
//        let action2 = UIAlertAction(title: "Action 2", style: .default, handler: { (action) -> Void in
//            print("ACTION 2 selected!")
//        })
//        
//        let action3 = UIAlertAction(title: "Action 3", style: .default, handler: { (action) -> Void in
//            print("ACTION 3 selected!")
//        })
//        
//        // Cancel button
//        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
//        
//        alert.view.tintColor = UIColor.brown  // change text color of the buttons
//        alert.view.backgroundColor = UIColor.cyan  // change background color
//        alert.view.layer.cornerRadius = 25   // change corner radius
//        
//        // Add action buttons and present the Alert
//        alert.addAction(action1)
//        alert.addAction(action2)
//        alert.addAction(action3)
//        alert.addAction(cancel)
//        present(alert, animated: true, completion: nil)
//    }
}
