//
//  PPEntryViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 20/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPEntryViewController: UIViewController, UITextFieldDelegate, PPPrefixSelectionDelegate
{
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var prefixView: UIView!
    @IBOutlet weak var countryLabel: UILabel!    
    @IBOutlet weak var prefixTF: UITextField!
    
    @IBOutlet weak var phoneNumberTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTapped))
        navigationItem.rightBarButtonItems = [nextButton]
        nextButton.isEnabled = false
        
        Utils.navigationBarToPayProStyle(navigationBar: (self.navigationController?.navigationBar)!)
        
        let prefixViewGR = UITapGestureRecognizer(target: self, action: #selector(showPrefixSelection))
        self.prefixView.addGestureRecognizer(prefixViewGR)
        
//        self.countryLabel.text = "ES"
//        self.prefixTF.text = "+34"
//        self.phoneNumberTF.text = "627737377"
        let borderTop = UIBezierPath(rect: CGRect(x: 0, y: 0.4, width: UIScreen.main.bounds.width, height: 0.4))
        let layerTop = CAShapeLayer()
        layerTop.path = borderTop.cgPath
        layerTop.fillColor = UIColor.lightGray.cgColor
        phoneView.layer.addSublayer(layerTop)
        
        let borderBottom = UIBezierPath(rect: CGRect(x: 0, y: phoneView.frame.height - 0.4, width: UIScreen.main.bounds.width, height: 0.4))
        let layerBottom = CAShapeLayer()
        layerBottom.path = borderBottom.cgPath
        layerBottom.fillColor = UIColor.lightGray.cgColor
        phoneView.layer.addSublayer(layerBottom)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextTapped()
    {
        User.mobileVerificationCode(phoneNumber: "\(self.prefixTF.text!)\(self.phoneNumberTF.text!)", completion: {userExistence in
            if userExistence
            {
                print("USER EXISTS")
                
                self.performSegue(withIdentifier: "showLoginVCSegue", sender: nil)
            }
            else
            {
                print("USER DOESN'T EXIST")
                
                self.performSegue(withIdentifier: "showSMSConfirmationVCSegue", sender: nil)
            }
        })
    }
    
    func showPrefixSelection()
    {
        self.performSegue(withIdentifier: "showPrefixSelectionVCSegue", sender: nil)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        
        navigationItem.rightBarButtonItem?.isEnabled = newLength > 0
        
        return true
    }
    
    //MARK: - PPPrefixSelectionDelegate
    
    func didSelectCountryPrefix(countryPrefix: String, countryName: String, countryISO2: String)
    {
        self.countryLabel.text = countryISO2
        self.prefixTF.text = countryPrefix
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showLoginVCSegue"
        {
            let passcodeVC : PPPasscodeViewController = segue.destination as! PPPasscodeViewController
            passcodeVC.userUsername = "\(self.prefixTF.text!)\(self.phoneNumberTF.text!)"
        }
        else if segue.identifier == "showSMSConfirmationVCSegue"
        {
            let smsConfirmationVC : PPSMSConfirmationViewController = segue.destination as! PPSMSConfirmationViewController
            smsConfirmationVC.userUsername = "\(self.prefixTF.text!)\(self.phoneNumberTF.text!)"
        }
        else if segue.identifier == "showPrefixSelectionVCSegue"
        {
            let prefixSelectionVC : PPPrefixSelectionViewController = segue.destination as! PPPrefixSelectionViewController
            prefixSelectionVC.delegate = self
            prefixSelectionVC.showPrefixes = true
        }
    }
}
