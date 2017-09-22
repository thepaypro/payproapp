//
//  PPSendMoneyAmountViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 6/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPSendMoneyAmountViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
    var sendMoney = SendMoney()
    
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBAction func nextTapped(_ sender: Any) {
        if (sendMoney.getOperationType() == 0 && sendMoney.getCurrencyType() == 0 || sendMoney.getOperationType() == 1){
            self.performSegue(withIdentifier: "beneficiaryNameSegue", sender: self)
        }else if (sendMoney.getOperationType() == 0 && sendMoney.getCurrencyType() == 1 || sendMoney.getOperationType() == 2){
            self.performSegue(withIdentifier: "resumToAmountSegue", sender: self)
        }
    }
    

    let currencyPickerData: [String] = ["£","µBTC"]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //disabled block load process
        
        self.currencyPicker.dataSource = self;
        self.currencyPicker.delegate = self;
        
        if sendMoney.getAmount() != "" {amountField.text = sendMoney.getAmount()}
        if sendMoney.getMessage() != "" {messageField.text = sendMoney.getMessage()}
        //currencyPicker
        
        
        amountField.addTarget(self, action: #selector(amountFieldDidChange), for: .editingChanged)
        messageField.addTarget(self, action: #selector(checkNavigation), for: .editingChanged)
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        let borderTop = UIBezierPath(rect: CGRect(x: 15, y: 0, width: self.view.frame.width - 30, height: 0.40))
        let layerTop = CAShapeLayer()
        layerTop.path = borderTop.cgPath
        layerTop.fillColor = PayProColors.line.cgColor
        self.messageView.layer.addSublayer(layerTop)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sendMoney.setLoadProcess(loadProcessValue: 0)
        self.amountField.becomeFirstResponder()
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
    }
    
    func amountFieldDidChange(_ textField: UITextField) {
        if let amountString = amountField.text?.currencyInputFormatting(currencyType: sendMoney.getCurrencyType()) {
                amountField.text = amountString
        }
        
        checkNavigation()
    }
    
    func checkNavigation() {
        if amountField.text?.checkValidAmount(currencyType: sendMoney.getCurrencyType()) == true && messageField.text != "" {
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
