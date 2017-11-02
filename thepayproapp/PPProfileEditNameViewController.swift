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
    @IBOutlet weak var nicknameView: UIView!
    @IBOutlet weak var nicknameInput: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let forenameBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let forenameLayerTop = CAShapeLayer()
        forenameLayerTop.path = forenameBorderTop.cgPath
        forenameLayerTop.fillColor = PayProColors.line.cgColor
        self.nicknameView.layer.addSublayer(forenameLayerTop)
        
        
        let lastnameBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 43.6, width: self.view.frame.width, height: 0.4))
        let lastnameLayerBottom = CAShapeLayer()
        lastnameLayerBottom.path = lastnameBorderBottom.cgPath
        lastnameLayerBottom.fillColor = PayProColors.line.cgColor
        self.nicknameView.layer.addSublayer(lastnameLayerBottom)
        
        
        nicknameInput.addTarget(self, action: #selector(checkNavigation), for: .editingChanged)
        
        self.setupView()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.nicknameInput.becomeFirstResponder()
        self.setupView()
    }
    
    func setupView()
    {
        let user = User.currentUser()
        
        self.nicknameInput.text = user?.nickname
        
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
        if nicknameInput.text != "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func nextTapped()
    {
        if self.nicknameInput.text != "" {
            self.displayNavBarActivity()
            
            let identifier: Int64 = Int64((User.currentUser()?.identifier)!)
            let nickname: String = String((self.nicknameInput.text)!)
            
            let accountUpdateDictionary = [
                "nickname": nickname,
                ] as [String : Any]
            
            UserUpdate(paramsDictionary: accountUpdateDictionary as NSDictionary, completion: { userUpdateResponse in
                
                if userUpdateResponse["status"] as! Bool == true {
                    let userDictionary = [
                        "id": identifier,
                        "nickname": nickname
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
                    
                    if userUpdateResponse["errorMessage"] != nil {
                        errorMessage = userUpdateResponse["errorMessage"] as! String
                    }
                    
                    self.dismissNavBarActivity()
                    self.setNavigationBarButton()
                    let alert = UIAlertController()
                    self.present(alert.displayAlert(code: errorMessage), animated: true, completion: nil)
                }
            })
        } else  {
            self.dismissNavBarActivity()
            self.setNavigationBarButton()
            let alert = UIAlertController()
            self.present(alert.displayAlert(code: "error_profile_saving_nickname"), animated: true, completion: nil)
        }
    }
    
    
}
