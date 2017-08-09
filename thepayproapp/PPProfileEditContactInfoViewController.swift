//
//  PPProfileEditContactInfoViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet Usó on 8/8/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPProfileEditContactInfoViewController: UIViewController
{
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailInput: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let phoneNumberBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let phoneNumberLayerTop = CAShapeLayer()
        phoneNumberLayerTop.path = phoneNumberBorderTop.cgPath
        phoneNumberLayerTop.fillColor = PayProColors.line.cgColor
        self.phoneNumberView.layer.addSublayer(phoneNumberLayerTop)
        
        let emailBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let emailLayerTop = CAShapeLayer()
        emailLayerTop.path = emailBorderTop.cgPath
        emailLayerTop.fillColor = PayProColors.line.cgColor
        self.emailView.layer.addSublayer(emailLayerTop)
        
        let emailBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 43.6, width: self.view.frame.width, height: 0.4))
        let emailLayerBottom = CAShapeLayer()
        emailLayerBottom.path = emailBorderBottom.cgPath
        emailLayerBottom.fillColor = PayProColors.line.cgColor
        self.emailView.layer.addSublayer(emailLayerBottom)
        
        emailInput.addTarget(self, action: #selector(checkNavigation), for: .editingChanged)
        
        self.setupView()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.emailInput.becomeFirstResponder()
        self.setupView()
    }
    
    func setupView()
    {
        let user = User.currentUser()
        
        self.phoneNumberLabel.text = user?.username
        self.emailInput.text = user?.email
        
        self.setNavigationBarButton()
    }
    
    func setNavigationBarButton()
    {
        let nextButton = UIBarButtonItem(title: "Confirm", style: .done, target: self, action: #selector(nextTapped))
        
        self.navigationItem.rightBarButtonItem = nextButton
        
        self.checkNavigation()
    }
    
    func checkNavigation() {
        if self.emailInput.text != "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func nextTapped()
    {
        if self.emailInput.text != "" {
            self.displayNavBarActivity()
            
            let identifier: Int64 = Int64((User.currentUser()?.identifier)!)
            let email: String = String((self.emailInput.text)!)
            
            let accountUpdateDictionary = [
                "email": email
                ] as [String : Any]
            
            AccountUpdate(paramsDictionary: accountUpdateDictionary as NSDictionary, completion: { accountUpdateResponse in
                
                if accountUpdateResponse["status"] as! Bool == true {
                    let userDictionary = [
                        "id": identifier,
                        "email": email
                        ] as [String : Any]
                    
                    let updateUser = User.manage(userDictionary: userDictionary as NSDictionary)
                    
                    if updateUser != nil {
                        self.dismissNavBarActivity()
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.dismissNavBarActivity()
                        self.setNavigationBarButton()
                        let alert = UIAlertController()
                        self.present(alert.displayAlert(code: "error_saving"), animated: true, completion: nil)
                    }
                } else {
                    self.dismissNavBarActivity()
                    self.setNavigationBarButton()
                    let alert = UIAlertController()
                    self.present(alert.displayAlert(code: "error_saving"), animated: true, completion: nil)
                }
            })
        } else if self.emailInput.text == "" {
            self.dismissNavBarActivity()
            self.setNavigationBarButton()
            let alert = UIAlertController()
            self.present(alert.displayAlert(code: "error_profile_saving_invalid_format"), animated: true, completion: nil)
        }
    }
    
    
}

