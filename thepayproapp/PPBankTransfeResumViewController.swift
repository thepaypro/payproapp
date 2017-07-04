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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        swipeColorBoxCenterX = self.swipeColorBox.center.x
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
        self.present(confirmViewController, animated: true, completion: nil)
    }
    
}

