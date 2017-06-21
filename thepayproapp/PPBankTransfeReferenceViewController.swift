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
    @IBOutlet weak var textInfoView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if self.labelReference.text == "Other" && self.viewOtherReason.isHidden == true {
            print("aa")
            self.textInfoView.frame.origin.y += 43
        }
        
        if self.labelReference.text != "Other" && self.viewOtherReason.isHidden == false {
            print("bb")
            self.textInfoView.frame.origin.y -= 43
        }
        
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
        self.labelReference.text = text
    }
}

