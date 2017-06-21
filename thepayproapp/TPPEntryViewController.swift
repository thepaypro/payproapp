//
//  TPPEntryViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 20/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class TPPEntryViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    convenience init()
    {
        self.init(nibName:nil, bundle:nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTapped))
        navigationItem.rightBarButtonItems = [nextButton]
        
        Utils.navigationBarToPayProStyle(navigationBar: (self.navigationController?.navigationBar)!)
        
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
            }
            else
            {
                print("USER DOESN'T EXIST")
            }
        })
        
        
    }
    
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 10 // Bool
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
