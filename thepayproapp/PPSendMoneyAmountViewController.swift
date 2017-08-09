//
//  PPSendMoneyAmountViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 6/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPSendMoneyAmountViewController: UIViewController
{
    var sendMoney = SendMoney()
    
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //disabled block load process
        sendMoney.setLoadProcess(loadProcessValue: 0)
        
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
        self.amountField.becomeFirstResponder()
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
        
        if segue.identifier == "resumToAmountIntraAppSegue"
        {
            let resumVC : PPBankTransfeResumViewController = segue.destination as! PPBankTransfeResumViewController
            resumVC.sendMoney = sendMoney
        }
    }
}
