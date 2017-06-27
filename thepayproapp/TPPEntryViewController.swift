//
//  TPPEntryViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 20/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class TPPEntryViewController: UIViewController, UITextFieldDelegate, TPPPrefixSelectionDelegate
{
    @IBOutlet weak var prefixView: UIView!
    @IBOutlet weak var countryLabel: UILabel!    
    @IBOutlet weak var prefixTF: UITextField!
    
    @IBOutlet weak var phoneNumberTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTapped))
        navigationItem.rightBarButtonItems = [nextButton]
        
        Utils.navigationBarToPayProStyle(navigationBar: (self.navigationController?.navigationBar)!)
        
        let prefixViewGR = UITapGestureRecognizer(target: self, action: #selector(showPrefixSelection))
        self.prefixView.addGestureRecognizer(prefixViewGR)
        
//        self.phoneNumberTF.text = "666666666"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextTapped()
    {
        User.checkExistence(username: phoneNumberTF.text!, completion: {userExistence in
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
        return true
    }
    
    //MARK: - TPPPrefixSelectionDelegate
    
    func didSelectCountryPrefix(countryPrefix: String, country: String)
    {
        self.countryLabel.text = country
        self.prefixTF.text = countryPrefix
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showLoginVCSegue"
        {
            let passcodeVC : TPPPasscodeViewController = segue.destination as! TPPPasscodeViewController
            passcodeVC.userUsername = phoneNumberTF.text
        }
        else if segue.identifier == "showSMSConfirmationVCSegue"
        {
            let smsConfirmationVC : TPPSMSConfirmationViewController = segue.destination as! TPPSMSConfirmationViewController
            smsConfirmationVC.userUsername = phoneNumberTF.text
        }
        else if segue.identifier == "showPrefixSelectionVCSegue"
        {
            let prefixSelectionVC : TPPPrefixSelectionViewController = segue.destination as! TPPPrefixSelectionViewController
            prefixSelectionVC.delegate = self
        }
    }

}
