//
//  PPProfileEditNameViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 13/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPProfileEditNameViewController: UIViewController
{
    @IBOutlet weak var forenameView: UIView!
    @IBOutlet weak var forenameInput: UITextField!
    @IBOutlet weak var lastnameView: UIView!
    @IBOutlet weak var lastnameInput: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let forenameBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let forenameLayerTop = CAShapeLayer()
        forenameLayerTop.path = forenameBorderTop.cgPath
        forenameLayerTop.fillColor = PayProColors.line.cgColor
        self.forenameView.layer.addSublayer(forenameLayerTop)
        
        let lastnameBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let lastnameLayerTop = CAShapeLayer()
        lastnameLayerTop.path = lastnameBorderTop.cgPath
        lastnameLayerTop.fillColor = PayProColors.line.cgColor
        self.lastnameView.layer.addSublayer(lastnameLayerTop)
        
        let lastnameBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 43.6, width: self.view.frame.width, height: 0.4))
        let lastnameLayerBottom = CAShapeLayer()
        lastnameLayerBottom.path = lastnameBorderBottom.cgPath
        lastnameLayerBottom.fillColor = PayProColors.line.cgColor
        self.lastnameView.layer.addSublayer(lastnameLayerBottom)
        
        
        forenameInput.addTarget(self, action: #selector(checkNavigation), for: .editingChanged)
        lastnameInput.addTarget(self, action: #selector(checkNavigation), for: .editingChanged)
        
        self.setupView()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.forenameInput.becomeFirstResponder()
        self.setupView()
    }
    
    func setupView()
    {
        let user = User.currentUser()
        
        self.forenameInput.text = user?.forename
        self.lastnameInput.text = user?.lastname
        
        self.setNavigationBarButton()
    }
    
    func setNavigationBarButton()
    {
        let nextButton = UIBarButtonItem(title: "Confirm", style: .done, target: self, action: #selector(nextTapped))
        
        self.navigationItem.rightBarButtonItem = nextButton
        
        self.checkNavigation()
    }
    
    func checkNavigation()
    {
        if forenameInput.text != "" && lastnameInput.text != "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func nextTapped()
    {
        if self.forenameInput.text != "" && self.lastnameInput.text != "" {
            self.displayNavBarActivity()
            
            let identifier: Int64 = Int64((User.currentUser()?.identifier)!)
            let forename: String = String((self.forenameInput.text)!)
            let lastname: String = String((self.lastnameInput.text)!)
            
            let accountUpdateDictionary = [
                "forename": forename,
                "lastname": lastname
                ] as [String : Any]
            
            AccountUpdate(paramsDictionary: accountUpdateDictionary as NSDictionary, completion: { accountUpdateResponse in
                
                if accountUpdateResponse["status"] as! Bool == true {
                    let userDictionary = [
                        "id": identifier,
                        "forename": forename,
                        "lastname": lastname
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
                    var errorMessage: String = "error_saving"
                    
                    if accountUpdateResponse["errorMessage"] != nil {
                        errorMessage = accountUpdateResponse["errorMessage"] as! String
                    }
                    
                    self.dismissNavBarActivity()
                    self.setNavigationBarButton()
                    let alert = UIAlertController()
                    self.present(alert.displayAlert(code: errorMessage), animated: true, completion: nil)
                }
            })
        } else if self.forenameInput.text == "" {
            self.dismissNavBarActivity()
            self.setNavigationBarButton()
            let alert = UIAlertController()
            self.present(alert.displayAlert(code: "error_profile_saving_forename"), animated: true, completion: nil)
        } else if self.lastnameInput.text == "" {
            self.dismissNavBarActivity()
            self.setNavigationBarButton()
            let alert = UIAlertController()
            self.present(alert.displayAlert(code: "error_profile_saving_lastname"), animated: true, completion: nil)
        }
    }
    
    
}
