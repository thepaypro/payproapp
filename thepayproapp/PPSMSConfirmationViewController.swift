//
//  PPSMSConfirmationViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 22/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPSMSConfirmationViewController: UIViewController, UITextFieldDelegate
{
    var userUsername : String!
    
    @IBOutlet weak var mainSMSCodeView: UIView!  
    
    @IBOutlet weak var smsCodeTF: UITextField!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.applyGradientBackground()
        
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTapped))
        nextButton.isEnabled = false
        navigationItem.rightBarButtonItems = [nextButton]
        
        smsCodeTF.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func applyGradientBackground()
    {
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [PayProColors.lightBlue.cgColor, PayProColors.blue.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func nextTapped()
    {
        self.performSegue(withIdentifier: "showCreatePasscodeSegue", sender: nil)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        
        if newLength <= self.mainSMSCodeView.subviews.count
        {
            let currentLabel = self.mainSMSCodeView.subviews[range.location].subviews.first as! UILabel
            currentLabel.text = string
                        
            navigationItem.rightBarButtonItems?.first?.isEnabled = newLength == self.mainSMSCodeView.subviews.count
            
            return true
        }
        
        return false
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showCreatePasscodeSegue"
        {
            let passcodeVC : PPPasscodeViewController = segue.destination as! PPPasscodeViewController
            passcodeVC.userUsername = userUsername
            passcodeVC.validationCode = smsCodeTF.text!
        }
    }    
}
