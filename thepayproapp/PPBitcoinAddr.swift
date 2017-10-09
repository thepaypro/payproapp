//
//  PPBitcoinAddr.swift
//  thepayproapp
//
//  Created by Roger Baiget on 5/10/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPBitcoinAddr: UIViewController{
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var input: UITextField!
    var sendMoney: SendMoney = SendMoney()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        input.becomeFirstResponder()
        self.sendMoney.setLoadProcess(loadProcessValue: 0)
    }
    
    func checkBitcoinAddr() -> Bool{
        if (input.text?.matchesRegex(regex: "^[13][a-km-zA-HJ-NP-Z0-9]{26,33}$"))! {
            self.sendMoney.setCurrencyType(currencyTypeValue: 1)
            self.sendMoney.setFixedCurrency(fixedCurrencyValue: true)
            self.sendMoney.setOperationType(operationTypeValue: 0)
            self.sendMoney.setBitcoinAddr(bitcoinAddrValue: input.text!)
            return true
        }else{
            let alert = UIAlertController()
            self.present(alert.displayAlert(code: "invalid_bitcoin_addr"), animated: true, completion: nil)
            input.becomeFirstResponder()
            return false
        }
    }
        
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendMoneyBitcoinAddrSegue" {
            let sendMoneyBitcoinVC : PPSendMoneyAmountViewController = segue.destination as! PPSendMoneyAmountViewController
            sendMoneyBitcoinVC.sendMoney = sendMoney
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "sendMoneyBitcoinAddrSegue" {
            return checkBitcoinAddr()
        } else {
            return true
        }
    }
}
