//
//  TPPPasscodeViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 21/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class TPPPasscodeViewController: UIViewController, UITextFieldDelegate
{
    var userUsername : String?
    
    @IBOutlet weak var mainPasscodeView: UIView!
    
    @IBOutlet weak var passcodeTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTapped))
        navigationItem.rightBarButtonItems = [nextButton]
                
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
            currentView.backgroundColor = UIColor.white
            
            currentView.layer.cornerRadius = currentView.frame.size.width / 2
            currentView.layer.borderWidth = 2.0
            currentView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    func nextTapped()
    {
        User.login(username: self.userUsername!, password: self.passcodeTF.text!, completion: {userExistence in
            
        })
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
                currentView.layer.backgroundColor = UIColor.groupTableViewBackground.cgColor
            }
        }
        
        if newLength < self.mainPasscodeView.subviews.count
        {
            for passcode in newLength...self.mainPasscodeView.subviews.count - 1
            {
                let currentView : UIView = self.mainPasscodeView.subviews[passcode]
                currentView.layer.backgroundColor = UIColor.white.cgColor
            }
        }
        
        return newLength <= self.mainPasscodeView.subviews.count
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
