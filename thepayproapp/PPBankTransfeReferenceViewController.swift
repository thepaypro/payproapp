//
//  PPBankTransfeReferenceViewController.swift
//  payproapp
//
//  Created by Enric Giribet on 20/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class TPPBankTransfeReferenceViewController: UIViewController, ReferenceViewControllerDelegate
{
    @IBOutlet weak var labelReference: UILabel!
    @IBOutlet weak var viewOtherReason: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("en will appear")
        
        if self.labelReference.text == "Other" {
            self.viewOtherReason.isHidden = false
        } else {
            self.viewOtherReason.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueReferenceList"{
            let vc = segue.destination as! PPBankTransfeReferenceListViewController
            vc.itemSelected = labelReference.text!
            vc.delegate = self
        }
    }
    
    func referenceSelected(controller: PPBankTransfeReferenceListViewController, text: String?) {
        print("aaabbbb")
        self.labelReference.text = text
        print(text ?? "nada de nada")
    }
}

