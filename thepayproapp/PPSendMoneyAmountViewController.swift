//
//  PPSendMoneyAmountViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 6/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPSendMoneyAmountViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate
{
    var sendMoney = SendMoney()
    
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBAction func nextTapped(_ sender: Any) {
        if (sendMoney.getOperationType() == 0 && sendMoney.getCurrencyType() == 0){
            self.performSegue(withIdentifier: "beneficiaryNameSegue", sender: self)
        }else if (sendMoney.getCurrencyType() == 1 || sendMoney.getOperationType() == 1 || sendMoney.getOperationType() == 2){
            self.performSegue(withIdentifier: "resumToAmountSegue", sender: self)
        }
    }
    
    let currencyPickerData: [String] = ["£","bits"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        amountField.delegate = self
        //disabled block load process
        
        self.currencyPicker.dataSource = self;
        self.currencyPicker.delegate = self;
        
        if let amount = sendMoney.getAmount(){
            amountField.text = amount
        }
        if let message = sendMoney.getMessage(){
            messageField.text = message
        }
        
        //currencyPicker
        currencyPicker.selectRow(sendMoney.getCurrencyType(), inComponent: 0, animated: false)
        
        
        amountField.addTarget(self, action: #selector(amountFieldDidChange), for: .editingChanged)
        messageField.addTarget(self, action: #selector(checkNavigation), for: .editingChanged)
        
        self.navigationItem.rightBarButtonItem?.isEnabled = (amountField.text?.checkValidAmount() == true && messageField.text != "")
        
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
        if self.sendMoney.getFixedCurrency() {
            currencyPicker.isHidden = true
            currencyLabel.isHidden = false
            (self.sendMoney.getCurrencyType() == 0) ? (currencyLabel.text = "£") : (currencyLabel.text = "bits")
        }else{
            currencyPicker.isHidden = false
            currencyLabel.isHidden = true
        }
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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyPickerData.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        sendMoney.setCurrencyType(currencyTypeValue: row)
        amountField.text = amountField.text?.currencyInputFormatting()
        
    }
    
    func amountFieldDidChange(_ textField: UITextField) {
        if let amountString = amountField.text?.currencyInputFormatting() {
                amountField.text = amountString
        }
        
        checkNavigation()
    }
    
    func checkNavigation() {
        if amountField.text?.checkValidAmount() == true && messageField.text != "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            sendMoney.setAmount(amountToSend: amountField.text!)
            sendMoney.setMessage(messageValue: messageField.text!)
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resumToAmountSegue"
        {
            let resumVC : PPBankTransfeResumViewController = segue.destination as! PPBankTransfeResumViewController
            resumVC.sendMoney = sendMoney
        }
        else if segue.identifier == "beneficiaryNameSegue"
        {
            let beneficiaryVC : PPBankTransfeViewController = segue.destination as! PPBankTransfeViewController
            beneficiaryVC.sendMoney = sendMoney
        }
    }
}
