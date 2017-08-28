//
//  PPAboutViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet Usó on 28/8/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPAboutViewController: UIViewController {
    
    @IBOutlet weak var aboutView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let aboutBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let aboutLayerTop = CAShapeLayer()
        aboutLayerTop.path = aboutBorderTop.cgPath
        aboutLayerTop.fillColor = PayProColors.line.cgColor
        self.aboutView.layer.addSublayer(aboutLayerTop)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
