//
//  PPInfoViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 23/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPInfoViewController: UIViewController
{
    var webViewOption = 0 //0:faqs, 1:terms, 2:community, 3:about
    
    @IBOutlet weak var infoView: UIView!
    @IBAction func faqsButton(_ sender: Any) {
        self.webViewOption = 0
    }
    @IBAction func termsButton(_ sender: Any) {
        self.webViewOption = 1
    }
    @IBAction func communityButton(_ sender: Any) {
        self.webViewOption = 2
    }
    @IBAction func aboutButton(_ sender: Any) {
        self.webViewOption = 3
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let infoBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let infoLayerTop = CAShapeLayer()
        infoLayerTop.path = infoBorderTop.cgPath
        infoLayerTop.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerTop)
        
        let infoBorder2 = UIBezierPath(rect: CGRect(x: 15, y: 43.6, width: self.view.frame.width, height: 0.4))
        let infoLayer2 = CAShapeLayer()
        infoLayer2.path = infoBorder2.cgPath
        infoLayer2.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayer2)
        
        let infoBorder3 = UIBezierPath(rect: CGRect(x: 15, y: 87.6, width: self.view.frame.width, height: 0.4))
        let infoLayer3 = CAShapeLayer()
        infoLayer3.path = infoBorder3.cgPath
        infoLayer3.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayer3)
        
        let infoBorder4 = UIBezierPath(rect: CGRect(x: 15, y: 131.6, width: self.view.frame.width, height: 0.4))
        let infoLayer4 = CAShapeLayer()
        infoLayer4.path = infoBorder4.cgPath
        infoLayer4.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayer4)
        
        let infoBorder5 = UIBezierPath(rect: CGRect(x: 15, y: 175.6, width: self.view.frame.width, height: 0.4))
        let infoLayer5 = CAShapeLayer()
        infoLayer5.path = infoBorder5.cgPath
        infoLayer5.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayer5)
        
        let infoBorder6 = UIBezierPath(rect: CGRect(x: 0, y: 219.6, width: self.view.frame.width, height: 0.4))
        let infoLayer6 = CAShapeLayer()
        infoLayer6.path = infoBorder6.cgPath
        infoLayer6.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayer6)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoWebViewSegue" {
            let webViewVC : PPInfoWebViewController = segue.destination as! PPInfoWebViewController
            webViewVC.loadOption = self.webViewOption
        }
    }
}

