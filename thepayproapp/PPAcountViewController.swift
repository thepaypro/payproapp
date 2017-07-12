//
//  AccountViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 13/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPAccountViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var cardHeight: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        scrollView.delegate = self
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.setupView()
    }
    
    func setupView()
    {
        scrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.width, y: 0.0)
        
        cardButton.isHidden = false
        cardHeight.constant = 60.0
        
        let cardStatus = User.currentUser()?.cardStatus
        
        if cardStatus == .notOrdered
        {
            cardButton.setTitle("Order Visa Debit Card", for: .normal)
        }
        else if cardStatus == .ordered
        {
            cardButton.setTitle("Activate Visa Debit Card", for: .normal)
        }
        else
        {
            cardButton.isHidden = true
            cardHeight.constant = 0.0
        }
    }
    
    @IBAction func cardButtonTouched(_ sender: Any)
    {
        let cardStatus = User.currentUser()?.cardStatus
        
        if cardStatus == .notOrdered
        {
            print("ORDER CARD")
        }
        else if cardStatus == .ordered
        {
            print("ACTIVATE CARD")
        }
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
