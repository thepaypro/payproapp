//
//  PPCardPinViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 4/8/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPCardPinViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cardActivationView: UIView!
    
    @IBOutlet weak var cardActivationTF: UITextField!
    
    var activateCode: String?
    var newPINCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if newPINCode != nil {
            let activateButton = UIBarButtonItem(title: "Activate", style: .done, target: self, action: #selector(nextTapped))
            activateButton.isEnabled = false
            
            navigationItem.rightBarButtonItems = [activateButton]
            
            self.titleLabel.text = "Confirm PIN code"
            self.descriptionLabel.text = "Confirm your PIN code for your card"
        } else {
            self.titleLabel.text = "New PIN code"
            self.descriptionLabel.text = "Enter new PIN code for your card"
        }
        
        cardActivationTF.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cardActivationTF.becomeFirstResponder()
    }
    
    func nextTapped()
    {
        if self.newPINCode == nil {
            self.performSegue(withIdentifier: "showConfirmPINCodeSegue", sender: nil)
        }
        else {
            CardActivation(
                activationCode: self.activateCode!,
                pinCode: self.newPINCode!,
                confirmCode: self.cardActivationTF.text!,
                completion: {
                    cardActivationResponse in
                    if cardActivationResponse["status"] as! Bool == true {
                        self.dismissNavBarActivity()
                        self.navigationController?.popToRootViewController(animated: false)
                    }
                }
            )
        }
    }
    
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        
        if newLength <= self.cardActivationView.subviews.count
        {
            let currentLabel = self.cardActivationView.subviews[range.location].subviews.first as! UILabel
            currentLabel.text = string
            
            if newPINCode != nil {
                navigationItem.rightBarButtonItems?.first?.isEnabled = newLength == self.cardActivationView.subviews.count
                
            } else if newLength == self.cardActivationView.subviews.count && string != "" {
                self.cardActivationTF.text = self.cardActivationTF.text! + string
                nextTapped()
            }
            
            return true
        }
        
        
        return false
    }
    
    /*
     // MARK: - Navigation
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConfirmPINCodeSegue" {
            let PINCodeVC : PPCardPinViewController = segue.destination as! PPCardPinViewController
            PINCodeVC.newPINCode = self.cardActivationTF.text
            PINCodeVC.activateCode = self.activateCode
        }
    }
}

