//
//  PPSendMoneyAmountViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 6/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPSendMoneyAmountViewController: UIViewController, UITextFieldDelegate
{
    var sendMoney = SendMoney()
    
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBAction func nextTapped(_ sender: Any) {
        if (sendMoney.getOperationType() == 0 && sendMoney.getCurrencyType() == 0){
            self.performSegue(withIdentifier: "beneficiaryNameSegue", sender: self)
        }else if (sendMoney.getCurrencyType() == 1 || sendMoney.getOperationType() == 1 || sendMoney.getOperationType() == 2){
            self.performSegue(withIdentifier: "resumToAmountSegue", sender: self)
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        amountField.delegate = self
        //disabled block load process

        if let amount = sendMoney.getAmount(){
            amountField.text = amount
        }
        if let message = sendMoney.getMessage(){
            messageField.text = message
        }
        
        amountField.addTarget(self, action: #selector(amountFieldDidChange), for: .editingChanged)
//        messageField.addTarget(self, action: #selector(checkNavigation), for: .editingChanged)
        
//        self.navigationItem.rightBarButtonItem?.isEnabled = (amountField.text?.checkValidAmount() == true && messageField.text != "")
        
        self.navigationItem.rightBarButtonItem?.isEnabled = (amountField.text?.checkValidAmount() == true)
        
        let borderTop = UIBezierPath(rect: CGRect(x: 15, y: 0, width: self.view.frame.width - 30, height: 0.40))
        let layerTop = CAShapeLayer()
        layerTop.path = borderTop.cgPath
        layerTop.fillColor = PayProColors.line.cgColor
        self.messageView.layer.addSublayer(layerTop)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sendMoney.setLoadProcess(loadProcessValue: 0)
        self.amountField.becomeFirstResponder()
        currencyLabel.isHidden = false
        currencyLabel.text = "bits"

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool{
        if(textField == amountField){
            let maxLength = 18
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else if(textField == messageField){
            let maxLength = 99
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else{
            return true
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func amountFieldDidChange(_ textField: UITextField) {
        if let amountString = amountField.text?.currencyInputFormatting() {
                amountField.text = amountString
        }
        
        checkNavigation()
    }
    
    func checkNavigation() {
//        if amountField.text?.checkValidAmount() == true && messageField.text != "" {
        if amountField.text?.checkValidAmount() == true {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resumToAmountSegue"
        {
            let resumVC : PPBankTransfeResumViewController = segue.destination as! PPBankTransfeResumViewController
            resumVC.sendMoney = sendMoney
            sendMoney.setAmount(amountToSend: amountField.text!)
            
            if messageField.text != "" {
                sendMoney.setMessage(messageValue: messageField.text!)
            } else {
                sendMoney.setMessage(messageValue: "Sent from PayPro App - download on the AppStore")
            }
        }
    }
}
