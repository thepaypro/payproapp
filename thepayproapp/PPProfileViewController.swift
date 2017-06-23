//
//  PPProfileViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 23/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPProfileViewController: UIViewController
{
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nationalView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var infoView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let avatarBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let avatarLayerTop = CAShapeLayer()
        avatarLayerTop.path = avatarBorderTop.cgPath
        avatarLayerTop.fillColor = PayProColors.line.cgColor
        self.avatarView.layer.addSublayer(avatarLayerTop)
        
        let avatarBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 75.5, width: self.view.frame.width, height: 0.4))
        let avatarLayerBottom = CAShapeLayer()
        avatarLayerBottom.path = avatarBorderBottom.cgPath
        avatarLayerBottom.fillColor = PayProColors.line.cgColor
        self.avatarView.layer.addSublayer(avatarLayerBottom)

        
        let nameBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let nameLayerTop = CAShapeLayer()
        nameLayerTop.path = nameBorderTop.cgPath
        nameLayerTop.fillColor = PayProColors.line.cgColor
        self.nameView.layer.addSublayer(nameLayerTop)
        
        let nameBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 43.5, width: self.view.frame.width, height: 0.4))
        let nameLayerBottom = CAShapeLayer()
        nameLayerBottom.path = nameBorderBottom.cgPath
        nameLayerBottom.fillColor = PayProColors.line.cgColor
        self.nameView.layer.addSublayer(nameLayerBottom)
        
        
        let nationalBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let nationalLayerTop = CAShapeLayer()
        nationalLayerTop.path = nationalBorderTop.cgPath
        nationalLayerTop.fillColor = PayProColors.line.cgColor
        self.nationalView.layer.addSublayer(nationalLayerTop)
        
        let nationalBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 43.5, width: self.view.frame.width, height: 0.4))
        let nationalLayerBottom = CAShapeLayer()
        nationalLayerBottom.path = nationalBorderBottom.cgPath
        nationalLayerBottom.fillColor = PayProColors.line.cgColor
        self.nationalView.layer.addSublayer(nationalLayerBottom)
        
        
        let addressBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let addressLayerTop = CAShapeLayer()
        addressLayerTop.path = addressBorderTop.cgPath
        addressLayerTop.fillColor = PayProColors.line.cgColor
        self.addressView.layer.addSublayer(addressLayerTop)
        
        let addressBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 119.5, width: self.view.frame.width, height: 0.4))
        let addressLayerBottom = CAShapeLayer()
        addressLayerBottom.path = addressBorderBottom.cgPath
        addressLayerBottom.fillColor = PayProColors.line.cgColor
        self.addressView.layer.addSublayer(addressLayerBottom)

        
        let infoBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let infoLayerTop = CAShapeLayer()
        infoLayerTop.path = infoBorderTop.cgPath
        infoLayerTop.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerTop)
        
        let infoBorderMiddle = UIBezierPath(rect: CGRect(x: 15, y: 43.5, width: self.view.frame.width, height: 0.4))
        let infoLayerMiddle = CAShapeLayer()
        infoLayerMiddle.path = infoBorderMiddle.cgPath
        infoLayerMiddle.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerMiddle)
        
        let infoBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 87.5, width: self.view.frame.width, height: 0.4))
        let infoLayerBottom = CAShapeLayer()
        infoLayerBottom.path = infoBorderBottom.cgPath
        infoLayerBottom.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerBottom)

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
