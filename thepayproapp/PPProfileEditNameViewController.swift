//
//  PPProfileEditNameViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 13/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPProfileEditNameViewController: UIViewController
{
    @IBOutlet weak var forenameView: UIView!
    @IBOutlet weak var forenameInput: UITextField!
    @IBOutlet weak var lastnameView: UIView!
    @IBOutlet weak var lastnameInput: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let forenameBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let forenameLayerTop = CAShapeLayer()
        forenameLayerTop.path = forenameBorderTop.cgPath
        forenameLayerTop.fillColor = PayProColors.line.cgColor
        self.forenameView.layer.addSublayer(forenameLayerTop)
        
        let lastnameBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let lastnameLayerTop = CAShapeLayer()
        lastnameLayerTop.path = lastnameBorderTop.cgPath
        lastnameLayerTop.fillColor = PayProColors.line.cgColor
        self.lastnameView.layer.addSublayer(lastnameLayerTop)
        
        let lastnameBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 43.6, width: self.view.frame.width, height: 0.4))
        let lastnameLayerBottom = CAShapeLayer()
        lastnameLayerBottom.path = lastnameBorderBottom.cgPath
        lastnameLayerBottom.fillColor = PayProColors.line.cgColor
        self.lastnameView.layer.addSublayer(lastnameLayerBottom)
        
        
//        let user = User.currentUser()
        
//        self.forenameView.text = user
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
