//
//  PPActivationCardViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 17/07/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPActivationCardViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var cardActivationView: UIView!
    
    @IBOutlet weak var cardActivationTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let activateButton = UIBarButtonItem(title: "Activate", style: .done, target: self, action: #selector(activateTapped))
        activateButton.isEnabled = false
        navigationItem.rightBarButtonItems = [activateButton]
        
        cardActivationTF.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func activateTapped()
    {
        NSLog("ACTIVATE CARD ENDPOINT %@", cardActivationTF.text!)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        
        if newLength <= self.cardActivationView.subviews.count
        {
            let currentLabel = self.cardActivationView.subviews[range.location].subviews.first as! UILabel
            currentLabel.text = string
            
            navigationItem.rightBarButtonItems?.first?.isEnabled = newLength == self.cardActivationView.subviews.count
            
            return true
        }
        
        return false
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
