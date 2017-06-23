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
    }
    
}

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "£"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
//
//        // remove from String: "$", ".", ","
//        let regex = try! NSRegularExpression(pattern: "[]", options: .caseInsensitive)
//        print(regex)
//        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "$1$2$3$4")
//        print(amountWithPrefix)
////        let double = (amountWithPrefix as NSString).doubleValue
////        print(double)
////        number = NSNumber(value: (double / 100))
////        print(number)
////        print("----")
////        // if first number is 0 or all numbers were deleted
////        guard number != 0 as NSNumber else {
////            print("return void")
////            return ""
////        }
////        
////        return formatter.string(from: number)!
//            return amountWithPrefix
//        var amountFormat = self.replacingOccurrences(of: "£", with: "")
//        amountFormat = amountFormat.replacingOccurrences(of: "a", with: "")
//        
//        return amountFormat
        
        let amount = self
//        var regex = try! NSRegularExpression(pattern: "[^0-9]", options: NSRegularExpression.Options.caseInsensitive)
//        var range = NSMakeRange(0, amount.characters.count)
//        var modString = regex.stringByReplacingMatches(in: amount, options: [], range: range, withTemplate: "")
//        
//        regex = try! NSRegularExpression(pattern: "[^,|\\.]", options: NSRegularExpression.Options.caseInsensitive)
//        range = NSMakeRange(0, modString.characters.count)
//        modString = regex.stringByReplacingMatches(in: modString, options: [], range: range, withTemplate: "")

        let matched  = matches(for: "^(\\d)+\\,?\\d{1,3}(\\.(\\d)?(\\d)?)?", in: amount)
        print(matched)
        return matched[0]

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
