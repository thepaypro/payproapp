//
//  PPBankTransfeAmountViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 20/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPBankTransfeAmountViewController: UIViewController
{
    var sendMoney = SendMoney()
    
    @IBOutlet weak var amountField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //disabled block load process
        sendMoney.setLoadProcess(loadProcessValue: 0)
        
        amountField.addTarget(self, action: #selector(amountFieldDidChange), for: .editingChanged)
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func amountFieldDidChange(_ textField: UITextField) {
        
        if let amountString = amountField.text?.currencyInputFormatting() {
            amountField.text = amountString
            sendMoney.setAmount(amountToSend: amountString)
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = (amountField.text?.checkValidAmount())!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "beneficiaryNameSegue"
        {
            let beneficiaryNameVC : PPBankTransfeViewController = segue.destination as! PPBankTransfeViewController
            beneficiaryNameVC.sendMoney = sendMoney
        }
    }
}
