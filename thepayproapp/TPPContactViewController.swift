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
        
        self.dismiss(animated: true, completion: {
            print("finish dismiss view")
        })
        
//        self.dismiss(animated: true)
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
