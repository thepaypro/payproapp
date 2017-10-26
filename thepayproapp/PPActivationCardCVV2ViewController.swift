//
//  PPActivationCardCVV2ViewController.swift
//  thepayproapp
//
//  Created by Roger Baiget on 13/9/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit
import AudioToolbox

class PPActivationCardCVV2ViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var CVV2View: UIView!
    
    @IBOutlet weak var CVV2TF: UITextField!
    
    var pin: String?
    var visiblePinScreenTime: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CVV2TF.becomeFirstResponder()
        CVV2TF.delegate = self
    
        navigationItem.rightBarButtonItems?.first?.isEnabled = false
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkCVV2(){
        let barButtonItems: [UIBarButtonItem]
        barButtonItems = self.displayNavBarActivity()!
        
        GetPin(
            CVV2: self.CVV2TF.text!,
            completion: {
                pinResponse in
                
                self.dismissNavBarActivity()
                self.navigationItem.rightBarButtonItems = barButtonItems
                self.navigationItem.rightBarButtonItems?.first?.isEnabled = true
                if pinResponse["status"] as! Bool == true {
                    self.pin = pinResponse["pin"] as? String
                    self.performSegue(withIdentifier: "showPINCodeFromCVV2Segue", sender: self)
                }else{
                    self.shake()
                    let when = DispatchTime.now() + .milliseconds(800)
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        let errorMessage: String = "error_on_get_pin"
                        let alert = UIAlertController()
                        self.present(alert.displayAlert(code: errorMessage), animated: true, completion: nil)
                    }
                }
            }
        )
    }
    
    func shake()
    {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        self.CVV2View.layer.add(animation, forKey: "shake")
        self.vibrateDevice()
        self.rebootCVV2()
    }
    
    func vibrateDevice()
    {
        AudioServicesPlaySystemSound(SystemSoundID (kSystemSoundID_Vibrate))
    }
    
    func rebootCVV2()
    {
        self.CVV2TF.text = ""
        
        for position in 0...self.CVV2View.subviews.count - 1
        {
            let currentLabel = self.CVV2View.subviews[position].subviews.first as! UILabel
            currentLabel.text = ""
        }
    }
    
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
    
        if newLength <= self.CVV2View.subviews.count
        {
            let currentLabel = self.CVV2View.subviews[range.location].subviews.first as! UILabel
            currentLabel.text = string
            
            if string != "" {
                let when = DispatchTime.now() + .milliseconds(200)
                DispatchQueue.main.asyncAfter(deadline: when) {
                    currentLabel.text = "*"
                }
            }

            if newLength == self.CVV2View.subviews.count && string != "" {
                self.CVV2TF.text = self.CVV2TF.text! + string
                checkCVV2()
            }

            return true
        }
        return false
    }
    
    /*
     // MARK: - Navigation
     */
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showPINCodeFromCVV2Segue" && self.pin == nil {
            self.checkCVV2()
            return false
        } else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPINCodeFromCVV2Segue" {
            let PINCodeVC : PPCardPinViewAfterActivationFormController = segue.destination as! PPCardPinViewAfterActivationFormController
            PINCodeVC.visiblePinScreenTime = self.visiblePinScreenTime
            PINCodeVC.CVV2 = self.CVV2TF.text
            PINCodeVC.pin = self.pin!
        }
    }
    
    
}
