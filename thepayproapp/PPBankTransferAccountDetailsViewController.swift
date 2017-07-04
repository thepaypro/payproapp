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

        let borderMiddle = UIBezierPath(rect: CGRect(x: 15, y: 42, width: self.view.frame.width, height: 0.4))
        let layerMiddle = CAShapeLayer()
        layerMiddle.path = borderMiddle.cgPath
        layerMiddle.fillColor = PayProColors.line.cgColor
        self.accountView.layer.addSublayer(layerMiddle)
        
        let borderBottom = UIBezierPath(rect: CGRect(x: 0, y: 41.5, width: self.view.frame.width, height: 0.4))
        let layerBottom = CAShapeLayer()
        layerBottom.path = borderBottom.cgPath
        layerBottom.fillColor = PayProColors.line.cgColor
        self.bicView.layer.addSublayer(layerBottom)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
