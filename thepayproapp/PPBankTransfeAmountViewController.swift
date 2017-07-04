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
    @IBOutlet weak var amountField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = (amountField.text?.check())!
    }
}

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        var amount = self.replacingOccurrences(of: "£", with: "")
        
        if amount.characters.last == "," {
            amount = String(amount.characters.dropLast()) + "."
        }
        
        amount = amount.replacingOccurrences(of: ",", with: "")
        amount = amount.replacingOccurrences(of: "..", with: ".")
        
        let matched = matches(for: "^\\d+((,[0-9]{0,3})+.|\\.[0-9]{0,2})?", in: amount)
        let matchedFull = matches(for: "^\\d+(,[0-9]{3})+\\.([0-9]{1,2})?", in: amount)
        
        if matchedFull.count > 0 {
            amount = matchedFull[0]
        } else if matched.count > 0 && matched[0] != "0"{
            amount = matched[0]
        } else {
            return ""
        }
        
        var amount_integer: String! = amount
        var amount_decimals: String! = ""
        var amount_decimals_origin: String! = ""
        let pos_dot = amount.range(of: ".", options: .backwards)?.lowerBound
        
        if pos_dot != nil {
            amount_integer = amount.substring(to: pos_dot!)
            amount_decimals_origin = amount.substring(from: pos_dot!)
            amount_decimals = amount_decimals_origin
            
            if amount_decimals_origin == "." {
                amount_decimals = ""
            }
        }
        
        let amount_number = Int(amount_integer)! as NSNumber
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.decimalSeparator = "."
        formatter.currencySymbol = "£"
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_GB")
        
        var amount_formatted = formatter.string(from: amount_number)
        
        if amount_decimals_origin != amount_decimals {
            amount_formatted = amount_formatted!+""+amount_decimals_origin
        } else {
            amount_formatted = amount_formatted!+""+amount_decimals
        }
        
        return amount_formatted!
    }
    
    func check() -> Bool {
        let amount = self.replacingOccurrences(of: "£", with: "")
        
        let matchedA = matches(for: "^\\d+$", in: amount)
        let matchedB = matches(for: "^\\d+(,[0-9]{3})+$", in: amount)
        let matchedC = matches(for: "^\\d+\\.[0-9]{1,2}$", in: amount)
        let matchedFull = matches(for: "^\\d+(,[0-9]{3})+\\.[0-9]{1,2}$", in: amount)
        
        if matchedA.count > 0 || matchedB.count > 0 || matchedC.count > 0 || matchedFull.count > 0{
            return true
        } else {
            return false
        }
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
