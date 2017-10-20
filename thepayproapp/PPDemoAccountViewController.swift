//
//  PPDemoAccountViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 19/07/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPDemoAccountViewController: UIViewController, CAAnimationDelegate
{

    @IBOutlet weak var latestTransactionsView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var accountReviewedButton: UIButton!
    @IBOutlet weak var swipeCurrencyGradientView: UIView!
    @IBOutlet weak var bitsBalanceLabel: UILabel!
    @IBOutlet weak var GBPBalanceLabel: UILabel!
    @IBOutlet weak var bitsView: UIView!
    @IBOutlet weak var bitsResizableView: UIView!
    @IBOutlet weak var GBPView: UIView!
    @IBOutlet weak var GBPResizableView: UIView!
    
    var isPositionFixed: Bool = true
    var selectedAccount: PPAccountViewController.AccountCurrencyType = .gbp
    
    @IBAction func swipeBitsViewLeft(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: bitsView, viewOneResizable: bitsResizableView, viewTwo: GBPView, viewTwoResizable: GBPResizableView, duration: Double(1.2), directionRight: false)
        }
    }
    @IBAction func swipeGBPViewLeft(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: GBPView, viewOneResizable: GBPResizableView, viewTwo: bitsView, viewTwoResizable: bitsResizableView, duration: Double(1.2), directionRight: false)
        }
    }
    @IBAction func swipeGBPViewRight(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: GBPView, viewOneResizable: GBPResizableView, viewTwo: bitsView, viewTwoResizable: bitsResizableView, duration: Double(1.2), directionRight: true)
        }
    }
    @IBAction func swipeBitsViewRight(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: bitsView, viewOneResizable: bitsResizableView, viewTwo: GBPView, viewTwoResizable: GBPResizableView, duration: Double(1.2), directionRight: true)
        }
    }
    @IBAction func swipeBitsViewDown(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: bitsView, viewOneResizable: bitsResizableView, viewTwo: GBPView, viewTwoResizable: GBPResizableView, duration: Double(1.2), directionRight: false)
        }
    }
    @IBAction func swipeBitsViewUp(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: bitsView, viewOneResizable: bitsResizableView, viewTwo: GBPView, viewTwoResizable: GBPResizableView, duration: Double(1.2), directionRight: true)
        }
    }
    @IBAction func swipeGBPViewDown(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: GBPView, viewOneResizable: GBPResizableView, viewTwo: bitsView, viewTwoResizable: bitsResizableView, duration: Double(1.2), directionRight: false)
        }
    }
    @IBAction func swipeGBPViewUp(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: GBPView, viewOneResizable: GBPResizableView, viewTwo: bitsView, viewTwoResizable: bitsResizableView, duration: Double(1.2), directionRight: true)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.firstTimeSetup()
        
        self.addGradient()
        
        let borderTop = UIBezierPath(rect: CGRect(x: 0, y: 0.4, width: UIScreen.main.bounds.width, height: 0.4))
        let layerTop = CAShapeLayer()
        layerTop.path = borderTop.cgPath
        layerTop.fillColor = UIColor.lightGray.cgColor
        latestTransactionsView.layer.addSublayer(layerTop)
        
        let borderBottom = UIBezierPath(rect: CGRect(x: 0, y: latestTransactionsView.bounds.height, width: UIScreen.main.bounds.width, height: 0.4))
        let layerBottom = CAShapeLayer()
        layerBottom.path = borderBottom.cgPath
        layerBottom.fillColor = UIColor.lightGray.cgColor
        latestTransactionsView.layer.addSublayer(layerBottom)
        
        if User.currentUser()?.status == User.Status.statusDemo {
            startButton.isHidden = false
            accountReviewedButton.isHidden = true
        
            let demoAccountAlert = UIAlertController(title: "", message: "In order to enjoy the advantages of the Visa debit card you need to start a free PayPro account", preferredStyle: .alert)
        
            let notNowAction = UIAlertAction(title: "Not now", style: .cancel, handler: nil)
        
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.performSegue(withIdentifier: "showChooseAccountVCSegue", sender: self)
            })
        
            demoAccountAlert.addAction(notNowAction)
            demoAccountAlert.addAction(OKAction)
            demoAccountAlert.preferredAction = OKAction
        
            self.present(demoAccountAlert, animated: true)
        } else {
            startButton.isHidden = true
            accountReviewedButton.isHidden = false
        }
    }
    
    func firstTimeSetup(){
        self.GBPResizableView.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.GBPResizableView.alpha = 0.7
        self.bitsResizableView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.bitsResizableView.alpha = 0.7
    }
    
    func addGradient(){
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = swipeCurrencyGradientView.bounds
        
        gradientLayer.colors = [PayProColors.blue.cgColor, PayProColors.gradientPink.cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.locations = [0.4,1]
        
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        swipeCurrencyGradientView.layer.addSublayer(gradientLayer)
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.checkUserStatus()
    }
    
    func checkUserStatus()
    {
        if User.currentUser()?.status == User.Status.statusDemo {
            startButton.isHidden = false
            accountReviewedButton.isHidden = true
        } else {
            startButton.isHidden = true
            accountReviewedButton.isHidden = false
        }

    }
    
    @IBAction func startNowButtonTouched(_ sender: Any)
    {
        performSegue(withIdentifier: "showChooseAccountVCSegue", sender: self)
    }
    
    fileprivate func setCurrencyAnimation(viewOne: UIView, viewOneResizable: UIView ,viewTwo: UIView, viewTwoResizable: UIView, duration: Double, directionRight: Bool) {
        isPositionFixed = false
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        let xviewOne = viewOne.center.x
        let yviewOne = viewOne.center.y
        let yviewTwo = viewTwo.center.y
        let viewOneOnTop: Bool = yviewOne < yviewTwo
        
        let pathOne: CGMutablePath  = CGMutablePath();
        let pathTwo: CGMutablePath  = CGMutablePath();
        let arcHeight = abs(yviewOne - yviewTwo)
        let arcCenter = CGPoint(x: xviewOne , y: yviewOne + (viewOneOnTop ? arcHeight/2 : -arcHeight/2));
        let angleOne = viewOneOnTop ? -CGFloat.pi/2 : CGFloat.pi/2
        let angleTwo = viewOneOnTop ? CGFloat.pi/2 : -CGFloat.pi/2
        
        
        pathOne.addArc(center: arcCenter, radius: arcHeight/2 ,startAngle: angleOne, endAngle: angleTwo, clockwise: viewOneOnTop ? (directionRight ?  false : true ) : (directionRight ?  true : false ))
        pathTwo.addArc(center: arcCenter, radius: arcHeight/2 ,startAngle: angleTwo, endAngle: angleOne, clockwise: viewOneOnTop ? (directionRight ?  false : true ) : (directionRight ?  true : false ))
        
        animation.path = pathOne
        animation.duration = duration
        animation.isCumulative = true;
        animation.isRemovedOnCompletion = false;
        animation.fillMode = kCAFillModeForwards
        animation.delegate = self
        
        viewOne.layer.add(animation, forKey: "move currency indicators along path")
        
        animation.path = pathTwo
        viewTwo.layer.add(animation, forKey: "move currency indicators along path")
        
        UIView.animate(withDuration: duration) {
            
            viewOneResizable.transform = CGAffineTransform(scaleX: viewOneOnTop ? 1:0.5, y: viewOneOnTop ? 1:0.5)
            viewOneResizable.alpha = 0.7
            viewTwoResizable.transform = CGAffineTransform(scaleX: viewOneOnTop ? 0.5:1, y: viewOneOnTop ? 0.5:1)
            viewTwoResizable.alpha = 0.7
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if !isPositionFixed {
            let GBPViewy = GBPView.center.y
            GBPView.center.y = bitsView.center.y
            bitsView.center.y = GBPViewy
            selectedAccount = GBPView.center.y > bitsView.center.y ? .gbp : .bitcoin
            isPositionFixed = true
        }
    }

}
