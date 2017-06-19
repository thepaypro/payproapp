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
//        self.addChildViewController(contactPickerScene)
//        self.view.addSubview(contactPickerScene.view)
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
    
    func showAlert() {
        let alert = UIAlertController(title: "Send money by", message: "", preferredStyle: .actionSheet)
        
        let bankTransfeButtonAction = UIAlertAction(title: "Bank transfer", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            //bankTransfeNavID
            
//            UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
            
            self.performSegue(withIdentifier: "bankTransfeSegue", sender: self)

//            classControlProcess.cd()
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier:"TPPBankTransfeViewController")
////            UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(nextViewController, animated:true, completion:nil)
//            UIApplication.shared.keyWindow?.rootViewController?.navigationController?.pushViewController(nextViewController, animated: true)
//            print("88999")
            
            
            //            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            //
            //            let nextViewController = storyBoard.instantiateViewController(withIdentifier:"TPPBankTransfeViewController")
            //
            //            UIApplication.shared.keyWindow?.rootViewController?.navigationController?.pushViewController(nextViewController, animated: true)
            //            print("aabbbaaabb22222")
        })
        
        alert.addAction(bankTransfeButtonAction)
        
        let inviteButtonAction = UIAlertAction(title: "Invite someone to PayPro", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            print("Second Button pressed")
        })
        
        alert.addAction(inviteButtonAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(alert, animated: true, completion: nil)
        
        print("fiiiin")

    }
}
