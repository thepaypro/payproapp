//
//  PPActivationCardViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 17/07/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPActivationCardViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var cardActivationView: UIView!
    
    @IBOutlet weak var cardActivationTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.performSegue(withIdentifier: "showPINCodeFromActivateCardSegue", sender: nil)
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
            
            navigationItem.rightBarButtonItems?.first?.isEnabled = newLength == self.cardActivationView.subviews.count
            
            if newLength == self.cardActivationView.subviews.count && string != "" {
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
        if segue.identifier == "showPINCodeFromActivateCardSegue" {
            let PINCodeVC : PPCardPinViewController = segue.destination as! PPCardPinViewController
            PINCodeVC.activateCode = cardActivationTF.text
        }
    }
}
