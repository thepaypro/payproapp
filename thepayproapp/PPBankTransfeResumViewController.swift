//
//  PPBankTransfeResumViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 29/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

var swipeColorBoxCenterX: CGFloat = 0.0

class PPBankTransfeResumViewController: UIViewController
{
    var sendMoney = SendMoney()
    
    @IBOutlet weak var superView: UIView!
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let status = sender.state.rawValue
        
        if let gestureView = sender.view {
            var newX = gestureView.center.x + translation.x
            
            if newX >= self.swipeBaseBox.center.x {
                newX = self.swipeBaseBox.center.x
            }
            
            if status == 3 {
                // if view displaced more or equal to 80% set complete 100%
                if self.swipeColorBox.center.x >= self.swipeBaseBox.center.x * 0.80 {
                    animateSwipe(position: self.swipeBaseBox.center.x)
                    vibrateDevice()
                    goToConfirm()
                } else {
                    animateSwipe(position: swipeColorBoxCenterX)
                }
            } else {
                gestureView.center = CGPoint(x: newX, y: gestureView.center.y)
            }
        }
        
        sender.setTranslation(CGPoint.zero, in: sender.view)

    }
    @IBOutlet weak var swipeImage: UIImageView!
    @IBOutlet weak var swipeBaseBox: UIView!
    @IBOutlet weak var swipeColorBox: UIView!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var infoView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        swipeColorBoxCenterX = self.swipeColorBox.center.x
        
        self.amountLabel.text = sendMoney.getAmount()
        
        if sendMoney.getOperationType() == 0 {
            self.firstLabel.text = sendMoney.getForename()+" "+sendMoney.getLastname()
            
            if sendMoney.getAccountDetailsType() == 0 {
                self.secondLabel.text = sendMoney.getAccountNumber()+" "+sendMoney.getShortcode()
            } else if sendMoney.getAccountDetailsType() == 1 {
                self.secondLabel.text = sendMoney.getIban()+" "+sendMoney.getBic()
            }
            
            self.thirdLabel.text = sendMoney.getMessage()
            
            if sendMoney.getReason() == "Other" {
                self.fourthLabel.text = sendMoney.getReason()+": "+sendMoney.getReasonExplain()
            } else {
                self.fourthLabel.text = sendMoney.getReason()
            }
            
        } else if sendMoney.getOperationType() == 1 {
            self.amountLabel.text = sendMoney.getAmount()
            self.firstLabel.text = sendMoney.getBeneficiaryName()
            self.secondLabel.text = sendMoney.getMessage()
        }
        
        let amountBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let amountLayerTop = CAShapeLayer()
        amountLayerTop.path = amountBorderTop.cgPath
        amountLayerTop.fillColor = PayProColors.line.cgColor
        self.amountView.layer.addSublayer(amountLayerTop)
        
        let amountBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 105.6, width: self.view.frame.width, height: 0.4))
        let amountLayerBottom = CAShapeLayer()
        amountLayerBottom.path = amountBorderBottom.cgPath
        amountLayerBottom.fillColor = PayProColors.line.cgColor
        self.amountView.layer.addSublayer(amountLayerBottom)
        
        let infoBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let infoLayerTop = CAShapeLayer()
        infoLayerTop.path = infoBorderTop.cgPath
        infoLayerTop.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerTop)
        
        let infoBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 98.6, width: self.view.frame.width, height: 0.4))
        let infoLayerBottom = CAShapeLayer()
        infoLayerBottom.path = infoBorderBottom.cgPath
        infoLayerBottom.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerBottom)
        
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
    
    func animateSwipe(position: CGFloat)
    {
        UIView.animate(withDuration: 0.2) {
            self.swipeColorBox.center = CGPoint(x: CGFloat(position), y: self.swipeColorBox.center.y)
        }
    }
    
    func vibrateDevice()
    {
        AudioServicesPlaySystemSound(SystemSoundID (kSystemSoundID_Vibrate))
    }
    
    func goToConfirm()
    {
        let confirmViewController = PPSendMoneyConfirmViewController()
        confirmViewController.modalTransitionStyle = .crossDissolve
        confirmViewController.sendMoney = sendMoney
        self.present(confirmViewController, animated: true, completion: nil)
    }
    
}

