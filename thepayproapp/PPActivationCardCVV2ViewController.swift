//
//  PPActivationCardCVV2ViewController.swift
//  thepayproapp
//
//  Created by Roger Baiget on 13/9/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPActivationCardCVV2ViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var CVV2View: UIView!
    
    @IBOutlet weak var CVV2TF: UITextField!
    
    var CVV2: String?
    var pin: String = ""
    let visiblePinScreenTime: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CVV2TF.becomeFirstResponder()
        
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTapped))
        nextButton.isEnabled = false
        
        navigationItem.rightBarButtonItems = [nextButton]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextTapped()
    {
            self.performSegue(withIdentifier: "showPINCodeFromActivateCardFormSegue", sender: nil)
    }
    func checkCVV2 () -> Bool{
        var result: Bool = false
        self.displayNavBarActivity()
        GetPin(
            completion: {
                pinResponse in
                self.dismissNavBarActivity()
                if pinResponse["status"] as! Bool == true {
                    print("pinResponse: \(pinResponse)")
                    self.pin = pinResponse["pin"] as! String
                    result = true
                }else{
                    if let errorMessage = pinResponse["errorMessage"] {
                        let alert = UIAlertController()
                        self.present(alert.displayAlert(code: errorMessage as! String), animated: true, completion: nil)
                    }else{
                        let errorMessage: String = "error"
                        let alert = UIAlertController()
                        self.present(alert.displayAlert(code: errorMessage), animated: true, completion: {
                            
                        })
                    }
                    print("getPinError")
                    result = false
                }
            }
        )
        return result
    }
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        
        if newLength <= self.CVV2View.subviews.count
        {
            let currentLabel = self.CVV2View.subviews[range.location].subviews.first as! UILabel
            currentLabel.text = string
            
            if CVV2 != nil {
                navigationItem.rightBarButtonItems?.first?.isEnabled = newLength == self.CVV2View.subviews.count
                
            } else if newLength == self.CVV2View.subviews.count && string != "" {
                self.CVV2TF.text = self.CVV2TF.text! + string
                nextTapped()
            }
            return true
        }
        return false
    }
    
    /*
     // MARK: - Navigation
     */
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showPINCodeFromCVV2Segue" {
            return checkCVV2()
        } else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPINCodeFromCVV2Segue" {
            let PINCodeVC : PPCardPinViewAfterActivationFormController = segue.destination as! PPCardPinViewAfterActivationFormController
            PINCodeVC.visiblePinScreenTime = self.visiblePinScreenTime
            PINCodeVC.CVV2 = self.CVV2TF.text
            PINCodeVC.pin = self.pin
        }
    }
    
    
}
