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
    
    @IBOutlet weak var forenameView: UIView!
    @IBOutlet weak var lastnameView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButton))
        
        let borderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.40))
        let layerTop = CAShapeLayer()
        layerTop.path = borderTop.cgPath
        layerTop.fillColor = PayProColors.line.cgColor
        self.forenameView.layer.addSublayer(layerTop)
        
        let borderMiddle = UIBezierPath(rect: CGRect(x: 15, y: 42, width: self.view.frame.width, height: 0.40))
        let layerMiddle = CAShapeLayer()
        layerMiddle.path = borderMiddle.cgPath
        layerMiddle.fillColor = PayProColors.line.cgColor
        self.forenameView.layer.addSublayer(layerMiddle)
        
        let borderBottom = UIBezierPath(rect: CGRect(x: 0, y: 41.5, width: self.view.frame.width, height: 0.40))
        let layerBottom = CAShapeLayer()
        layerBottom.path = borderBottom.cgPath
        layerBottom.fillColor = PayProColors.line.cgColor
        self.lastnameView.layer.addSublayer(layerBottom)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func backButton() {
        print("in backButton")
        
        self.dismiss(animated: true, completion: nil)

    }
}

