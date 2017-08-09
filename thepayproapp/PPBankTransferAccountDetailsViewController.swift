//
//  PPBankTransferAccountDetailsViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 21/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPBankTransferAccountDetailsViewController: UIViewController
{
    var sendMoney = SendMoney()
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var ibanLabel: UILabel!
    @IBOutlet weak var ibanField: UITextField!
    @IBOutlet weak var bicLabel: UILabel!
    @IBOutlet weak var bicField: UITextField!
    @IBOutlet weak var shortcodeLabel: UILabel!
    @IBOutlet weak var shortcodeField: UITextField!
    @IBOutlet weak var segmentControlField: UISegmentedControl!
    @IBAction func segmentControlAction(_ sender: Any) {
        if segmentControlField.selectedSegmentIndex == 0 {
            self.accountLabel.isHidden = false
            self.accountField.isHidden = false
            self.shortcodeLabel.isHidden = false
            self.shortcodeField.isHidden = false
            
            self.ibanLabel.isHidden = true
            self.ibanField.isHidden = true
            self.bicLabel.isHidden = true
            self.bicField.isHidden = true
        } else if segmentControlField.selectedSegmentIndex == 1 {
            self.accountLabel.isHidden = true
            self.accountField.isHidden = true
            self.shortcodeLabel.isHidden = true
            self.shortcodeField.isHidden = true
            
            self.ibanLabel.isHidden = false
            self.ibanField.isHidden = false
            self.bicLabel.isHidden = false
            self.bicField.isHidden = false
        }
    }
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var bicView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        accountField.addTarget(self, action: #selector(checkNavigation), for: .editingChanged)
        shortcodeField.addTarget(self, action: #selector(checkNavigation), for: .editingChanged)
        ibanField.addTarget(self, action: #selector(checkNavigation), for: .editingChanged)
        bicField.addTarget(self, action: #selector(checkNavigation), for: .editingChanged)
        
        if segmentControlField.selectedSegmentIndex == 0 {
            self.accountLabel.isHidden = false
            self.accountField.isHidden = false
            self.shortcodeLabel.isHidden = false
            self.shortcodeField.isHidden = false
            
            self.ibanLabel.isHidden = true
            self.ibanField.isHidden = true
            self.bicLabel.isHidden = true
            self.bicField.isHidden = true
        } else if segmentControlField.selectedSegmentIndex == 1 {
            self.accountLabel.isHidden = true
            self.accountField.isHidden = true
            self.shortcodeLabel.isHidden = true
            self.shortcodeField.isHidden = true
            
            self.ibanLabel.isHidden = false
            self.ibanField.isHidden = false
            self.bicLabel.isHidden = false
            self.bicField.isHidden = false
        }
        
        
        let borderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let layerTop = CAShapeLayer()
        layerTop.path = borderTop.cgPath
        layerTop.fillColor = PayProColors.line.cgColor
        self.accountView.layer.addSublayer(layerTop)

        let borderMiddle = UIBezierPath(rect: CGRect(x: 15, y: 42.6, width: self.view.frame.width, height: 0.4))
        let layerMiddle = CAShapeLayer()
        layerMiddle.path = borderMiddle.cgPath
        layerMiddle.fillColor = PayProColors.line.cgColor
        self.accountView.layer.addSublayer(layerMiddle)
        
        let borderBottom = UIBezierPath(rect: CGRect(x: 0, y: 41.6, width: self.view.frame.width, height: 0.4))
        let layerBottom = CAShapeLayer()
        layerBottom.path = borderBottom.cgPath
        layerBottom.fillColor = PayProColors.line.cgColor
        self.bicView.layer.addSublayer(layerBottom)

    }
    
    func checkNavigation() {
        if segmentControlField.selectedSegmentIndex == 0 && accountField.text != "" && shortcodeField.text != "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            sendMoney.setAccountDetailsType(accountDetailsTypeValue: 0)
            sendMoney.setAccountNumber(accountNumberValue: self.accountField.text!)
            sendMoney.setShortcode(shortcodeValue: self.shortcodeField.text!)
            
            sendMoney.setIban(ibanValue: "")
            sendMoney.setBic(bicValue: "")
            
        } else if segmentControlField.selectedSegmentIndex == 1 && ibanField.text != "" && bicField.text != "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            sendMoney.setAccountDetailsType(accountDetailsTypeValue: 1)
            sendMoney.setIban(ibanValue: self.ibanField.text!)
            sendMoney.setBic(bicValue: self.bicField.text!)
            
            sendMoney.setAccountNumber(accountNumberValue: "")
            sendMoney.setShortcode(shortcodeValue: "")
            
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        if segmentControlField.selectedSegmentIndex == 0 {
            self.accountField.becomeFirstResponder()
        } else if segmentControlField.selectedSegmentIndex == 1 {
            self.ibanField.becomeFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "reasonSegue"
        {
            let reasonVC : PPBankTransfeReferenceViewController = segue.destination as! PPBankTransfeReferenceViewController
            reasonVC.sendMoney = sendMoney
        }
    }
    
}
