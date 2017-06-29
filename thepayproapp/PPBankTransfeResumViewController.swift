//
//  PPBankTransfeResumViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 29/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPBankTransfeResumViewController: UIViewController
{

    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
//        print(self.swipeColorBox.center.x)
//        print(self.swipeBaseBox.center.x)
//        print(self.swipeColorBox.frame.origin.x)

        let translation = sender.translation(in: self.view)
        let status = sender.state.rawValue
        
        if let gestureView = sender.view {
            var newX = gestureView.center.x + translation.x
            
            if self.swipeBaseBox.center.x <= newX {
                newX = gestureView.center.x
            }
            print(status)
            print(newX)
            print(self.swipeBaseBox.center.x * 0.80)
            if status == 3 && newX < self.swipeBaseBox.center.x * 0.80{
                newX = self.swipeBaseBox.center.x * 0.20
                
            }
            
            gestureView.center = CGPoint(x: newX, y: gestureView.center.y)
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
        
//        print(self.swipeBaseBox.frame.size.width)
//        print(self.swipeBaseBox.frame.origin.x)
//        print(self.swipeBaseBox.frame.origin.y)
//        print(self.swipeBaseBox.center.x)
//        print(self.swipeBaseBox.center.y)
//        
//        print(self.swipeColorBox.frame.size.width)
//        print(self.swipeColorBox.frame.origin.x)
//        print(self.swipeColorBox.frame.origin.y)
//        print(self.swipeColorBox.center.x)
//        print(self.swipeColorBox.center.y)
        
    }
    
    override func didReceiveMemoryWarning()
    {
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

