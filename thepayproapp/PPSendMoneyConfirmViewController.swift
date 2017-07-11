//
//  PPSendMoneyConfirmViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 3/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPSendMoneyConfirmViewController: UIViewController
{
    var sendMoney = SendMoney()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.view.backgroundColor = UIColor.white
        createGradientLayer()
        addConfirmText()
        transition()
    }
    
    func createGradientLayer() {
        let box = UIView()
        box.frame = CGRect(x: 0, y:0, width: self.view.frame.width, height: self.view.frame.height)
        box.backgroundColor = UIColor.white
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = box.bounds
        gradientLayer.colors = [PayProColors.gradientBackgroundBottom.cgColor, PayProColors.gradientBackgroundMiddle.cgColor, PayProColors.gradientBackgroundTop.cgColor]
        
        box.layer.addSublayer(gradientLayer)
        
        self.view.insertSubview(box, at: 0)
    }
    
    func addConfirmText()
    {
        let box = UIView()
        box.frame = CGRect(x: 0, y:0, width: self.view.frame.width, height: self.view.frame.height)
        
        let labelTop = UILabel()
        labelTop.text = "You rock!"
        labelTop.textAlignment = .center
        labelTop.textColor = UIColor.white
        labelTop.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
        labelTop.frame = CGRect(x: 0, y: (self.view.frame.height/2) - 125, width: self.view.frame.width, height: 20)
        self.view.addSubview(labelTop)
       
        let labelMiddle = UILabel()
        labelMiddle.text = sendMoney.getAmount()
        labelMiddle.textAlignment = .center
        labelMiddle.textColor = UIColor.white
        labelMiddle.font = UIFont.systemFont(ofSize: 42, weight: UIFontWeightLight)
        labelMiddle.frame = CGRect(x: 0, y: (self.view.frame.height/2) - 100, width: self.view.frame.width, height: 40)
        self.view.addSubview(labelMiddle)
        
        let labelBottom = UILabel()
        if sendMoney.getOperationType() == 0 {
            labelBottom.text = "sent to "+sendMoney.getForename()+" "+sendMoney.getLastname()
        } else if sendMoney.getOperationType() == 1 || sendMoney.getOperationType() == 2 {
            labelBottom.text = "sent to "+sendMoney.getBeneficiaryName()
        }        
        labelBottom.textAlignment = .center
        labelBottom.textColor = UIColor.white
        labelBottom.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
        labelBottom.frame = CGRect(x: 0, y: (self.view.frame.height/2) - 55, width: self.view.frame.width, height: 20)
        self.view.addSubview(labelBottom)
    }
    
    func transition()
    {
//        PPTabBarController().loadAmountTabItem()
        
        let when = DispatchTime.now() + 3 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.dismiss(animated: true, completion: nil)

        }
    }
    
}
