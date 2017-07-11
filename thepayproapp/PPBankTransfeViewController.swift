//
//  PPBankTransfeViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet Usó on 18/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPBankTransfeViewController: UIViewController
{
    var sendMoney = SendMoney()
    
    @IBOutlet weak var forenameView: UIView!
    @IBOutlet weak var lastnameView: UIView!
    @IBOutlet weak var forenameInput: UITextField!
    @IBOutlet weak var lastnameInput: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        forenameInput.addTarget(self, action: #selector(checkNavigation), for: .editingChanged)
        lastnameInput.addTarget(self, action: #selector(checkNavigation), for: .editingChanged)
        
        let borderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.40))
        let layerTop = CAShapeLayer()
        layerTop.path = borderTop.cgPath
        layerTop.fillColor = PayProColors.line.cgColor
        self.forenameView.layer.addSublayer(layerTop)
        
        let borderMiddle = UIBezierPath(rect: CGRect(x: 15, y: 42.6, width: self.view.frame.width, height: 0.40))
        let layerMiddle = CAShapeLayer()
        layerMiddle.path = borderMiddle.cgPath
        layerMiddle.fillColor = PayProColors.line.cgColor
        self.forenameView.layer.addSublayer(layerMiddle)
        
        let borderBottom = UIBezierPath(rect: CGRect(x: 0, y: 41.6, width: self.view.frame.width, height: 0.40))
        let layerBottom = CAShapeLayer()
        layerBottom.path = borderBottom.cgPath
        layerBottom.fillColor = PayProColors.line.cgColor
        self.lastnameView.layer.addSublayer(layerBottom)
    }
    
    func checkNavigation() {
        if forenameInput.text != "" && lastnameInput.text != "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            sendMoney.setForename(forenameValue: self.forenameInput.text!)
            sendMoney.setLastname(lastnameValue: self.lastnameInput.text!)

        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "accountDetailsSegue"
        {
            let amountDetailsVC : PPBankTransferAccountDetailsViewController = segue.destination as! PPBankTransferAccountDetailsViewController
            amountDetailsVC.sendMoney = sendMoney
        }
    }

}

