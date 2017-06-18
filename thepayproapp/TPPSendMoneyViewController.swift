//
//  TPPSendMoneyViewController.swift
//  payproapp
//
//  Created by Manuel Ortega Cordovilla on 13/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

var classControlProcess = TPPSendMoneyViewController()


class TPPSendMoneyViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("en viewDidLoad de Send Money")
        
        if let contactView = storyboard?.instantiateViewController(withIdentifier: "contactViewID") {
            self.addChildViewController(contactView)
            self.view.addSubview(contactView.view)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("bbbbbbbbbbbbbbbbbbb")
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if let contactView = storyboard?.instantiateViewController(withIdentifier: "contactViewID") {
//            self.addChildViewController(contactView)
//            self.view.addSubview(contactView.view)
//        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func fs() {
        print("wwwwaaa")
        
        let alert = UIAlertController(title: "Send money by", message: "", preferredStyle: .actionSheet)
        
        let bankTransfeButtonAction = UIAlertAction(title: "Bank transfer", style: UIAlertActionStyle.default, handler: {
             action in
            //bankTransfeNavID
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier:"TPPBankTransfeViewController")
            UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(nextViewController, animated:true, completion:nil)
        })
        
        alert.addAction(bankTransfeButtonAction)
        
        let inviteButtonAction = UIAlertAction(title: "Invite someone to PayPro", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            print("Second Button pressed")
        })
        
        alert.addAction(inviteButtonAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(alert, animated: true, completion: nil)
        
        print("fiiiin")
    }
    
    private func presentViewController(alert: UIAlertController, animated flag: Bool, completion: (() -> Void)?) -> Void {
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: flag, completion: completion)
    }
}
