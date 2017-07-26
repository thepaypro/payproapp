//
//  PPPasscodeViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 21/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPPasscodeViewController: UIViewController, UITextFieldDelegate
{
    var userUsername : String?
    
    var validationCode : String?
    
    var firstPassword : String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var mainPasscodeView: UIView!
    
    @IBOutlet weak var passcodeTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTapped))
        navigationItem.rightBarButtonItem = nextButton
        nextButton.isEnabled = false
        
        if validationCode != nil
        {
            titleLabel.text = "Create a passcode"
            descriptionLabel.text = "A passcode protects your data and is used to unlock the PayPro app"
            
            if firstPassword != nil
            {
                titleLabel.text = "Confirm your passcode"
            }
            
            self.navigationItem.title = "Passcode"
        }
        else
        {
            titleLabel.text = "Enter your Passcode in PayPro"
            descriptionLabel.text = "Enter your passcode to unlock the PayPro app"
            
            self.navigationItem.title = "Log in"
        }
        
        self.applyGradientBackground()
                
        passcodeTF.becomeFirstResponder()
        
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView()
    {
        for currentView: UIView in self.mainPasscodeView.subviews
        {
            currentView.backgroundColor = UIColor.clear
            
            currentView.layer.cornerRadius = currentView.frame.size.width / 2
            currentView.layer.borderWidth = 2.0
            currentView.layer.borderColor = UIColor.white.cgColor
        }
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
        if validationCode != nil {
            if firstPassword != nil {
                self.displayNavBarActivity()
                
                User.register(username: userUsername!, password: firstPassword!, passwordConfirmation: passcodeTF.text!, validationCode: validationCode!, completion: {successRegister in
                    if successRegister {
                        self.dismissNavBarActivity()
                        self.performSegue(withIdentifier: "showTabCSegue", sender: nil)
                    } else {
                        print("REGISTER FAILED")
                    }
                })
            } else {
                self.performSegue(withIdentifier: "showConfirmPasscodeSegue", sender: nil)
            }
        } else {
            self.displayNavBarActivity()
            
            User.login(username: self.userUsername!, password: self.passcodeTF.text!, completion: {successLogin in
                if successLogin {
                    self.dismissNavBarActivity()
                    self.performSegue(withIdentifier: "showTabCSegue", sender: nil)
                } else {
                    print("LOGIN FAILED")
                }
            })
        }
    }
    
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        
        if newLength > 0 && newLength <= self.mainPasscodeView.subviews.count
        {
            for passcode in 0...newLength - 1
            {
                let currentView : UIView = self.mainPasscodeView.subviews[passcode]
                currentView.layer.backgroundColor = UIColor.white.cgColor
            }
        }
        
        if newLength < self.mainPasscodeView.subviews.count
        {
            for passcode in newLength...self.mainPasscodeView.subviews.count - 1
            {
                let currentView : UIView = self.mainPasscodeView.subviews[passcode]
                currentView.layer.backgroundColor = UIColor.clear.cgColor
            }
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = newLength == 6
        
        return newLength <= self.mainPasscodeView.subviews.count
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showConfirmPasscodeSegue"
        {
            let passcodeVC : PPPasscodeViewController = segue.destination as! PPPasscodeViewController
            passcodeVC.userUsername = userUsername
            passcodeVC.validationCode = validationCode
            passcodeVC.firstPassword = passcodeTF.text!
        }
        else if segue.identifier == "showTabCSegue"
        {
            let tabController : PPTabBarController = segue.destination as! PPTabBarController
            tabController.navigationItem.hidesBackButton = true
        }
    }
}
