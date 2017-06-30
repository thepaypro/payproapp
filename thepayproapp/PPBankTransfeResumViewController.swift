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
            
            if self.swipeBaseBox.center.x <= newX {
                newX = gestureView.center.x
            }
            
            let displaced = Swift.abs(swipeColorBoxCenterX - self.swipeColorBox.center.x)
            let finalXSwipe = self.swipeBaseBox.frame.width - self.swipeSmallBox.frame.width - Swift.abs(swipeColorBoxCenterX)
            
            // if view displaced more than total, force last value of movement position
            if displaced + self.swipeSmallBox.frame.width > self.swipeBaseBox.frame.width {
                newX = finalXSwipe
            }
            
            if status == 3 {
                // if view displaced more or equal to 80% set complete 100%
                if displaced + self.swipeSmallBox.frame.width >= self.swipeBaseBox.frame.width * 0.80 {
                    animateSwipe(position: finalXSwipe)
                    vibrateDevice()
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
    @IBOutlet weak var swipeSmallBox: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(self.swipeBaseBox.center.x)
        print(self.swipeBaseBox.frame.width)
        print(self.swipeColorBox.frame.width)
        print(self.swipeSmallBox.center.x)
        print(self.swipeColorBox.center.x)
        
        swipeColorBoxCenterX = self.swipeColorBox.center.x
        animateSwipe(position: 400)
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
        print("in vibrateDevice")
        AudioServicesPlaySystemSound(SystemSoundID (kSystemSoundID_Vibrate))
    }
    
}

