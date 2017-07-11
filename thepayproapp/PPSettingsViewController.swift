//
//  PPSettingsViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 13/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPSettingsViewController: UIViewController {

    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var upgradeView: UIView!
    @IBOutlet weak var infoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nameBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let nameLayerTop = CAShapeLayer()
        nameLayerTop.path = nameBorderTop.cgPath
        nameLayerTop.fillColor = PayProColors.line.cgColor
        self.nameView.layer.addSublayer(nameLayerTop)
        
        let nameBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 75.6, width: self.view.frame.width, height: 0.4))
        let nameLayerBottom = CAShapeLayer()
        nameLayerBottom.path = nameBorderBottom.cgPath
        nameLayerBottom.fillColor = PayProColors.line.cgColor
        self.nameView.layer.addSublayer(nameLayerBottom)
        
        
        let cardBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let cardLayerTop = CAShapeLayer()
        cardLayerTop.path = cardBorderTop.cgPath
        cardLayerTop.fillColor = PayProColors.line.cgColor
        self.cardView.layer.addSublayer(cardLayerTop)
        
        let cardBorderMiddle = UIBezierPath(rect: CGRect(x: 58, y: 43.6, width: self.view.frame.width, height: 0.4))
        let cardLayerMiddle = CAShapeLayer()
        cardLayerMiddle.path = cardBorderMiddle.cgPath
        cardLayerMiddle.fillColor = PayProColors.line.cgColor
        self.cardView.layer.addSublayer(cardLayerMiddle)
        
        let cardBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 87.6, width: self.view.frame.width, height: 0.4))
        let cardLayerBottom = CAShapeLayer()
        cardLayerBottom.path = cardBorderBottom.cgPath
        cardLayerBottom.fillColor = PayProColors.line.cgColor
        self.cardView.layer.addSublayer(cardLayerBottom)
        
        
        let upgradeBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let upgradeLayerTop = CAShapeLayer()
        upgradeLayerTop.path = upgradeBorderTop.cgPath
        upgradeLayerTop.fillColor = PayProColors.line.cgColor
        self.upgradeView.layer.addSublayer(upgradeLayerTop)
        
        let upgradeBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 43.6, width: self.view.frame.width, height: 0.4))
        let upgradeLayerBottom = CAShapeLayer()
        upgradeLayerBottom.path = upgradeBorderBottom.cgPath
        upgradeLayerBottom.fillColor = PayProColors.line.cgColor
        self.upgradeView.layer.addSublayer(upgradeLayerBottom)
        
        
        let infoBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let infoLayerTop = CAShapeLayer()
        infoLayerTop.path = infoBorderTop.cgPath
        infoLayerTop.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerTop)
        
        let infoBorderMiddle = UIBezierPath(rect: CGRect(x: 0, y: 43.6, width: self.view.frame.width, height: 0.4))
        let infoLayerMiddle = CAShapeLayer()
        infoLayerMiddle.path = infoBorderMiddle.cgPath
        infoLayerMiddle.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerMiddle)
        
        let infoBorderMiddleB = UIBezierPath(rect: CGRect(x: 0, y: 87.6, width: self.view.frame.width, height: 0.4))
        let infoLayerMiddleB = CAShapeLayer()
        infoLayerMiddleB.path = infoBorderMiddleB.cgPath
        infoLayerMiddleB.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerMiddleB)
        
        let infoBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 131.6, width: self.view.frame.width, height: 0.4))
        let infoLayerBottom = CAShapeLayer()
        infoLayerBottom.path = infoBorderBottom.cgPath
        infoLayerBottom.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerBottom)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
