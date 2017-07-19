//
//  PPDemoAccountViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 19/07/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPDemoAccountViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var accountDetailsView: UIView!
    @IBOutlet weak var latestTransactionsView: UIView!
    
    var transactionsArray : [Transaction]?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        scrollView.delegate = self
        
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
        
        let demoAccountAlert = UIAlertController(title: "", message: "In order to enjoy the advantages of the Visa debit card you need to start a free PayPro account", preferredStyle: .alert)
        
        let notNowAction = UIAlertAction(title: "Not now", style: .cancel, handler: nil)
        
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.performSegue(withIdentifier: "showChooseAccountVCSegue", sender: self)
        })
        
        demoAccountAlert.addAction(notNowAction)
        demoAccountAlert.addAction(OKAction)
        demoAccountAlert.preferredAction = OKAction
        
        self.present(demoAccountAlert, animated: true)
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
    
    override func viewDidLayoutSubviews()
    {
        scrollView.contentOffset = CGPoint(x: accountDetailsView.bounds.width, y: 0.0)
    }
    
    func setupView()
    {
        scrollView.contentOffset = CGPoint(x: accountDetailsView.bounds.width, y: 0.0)
    }
    
    @IBAction func startNowButtonTouched(_ sender: Any)
    {
        performSegue(withIdentifier: "showChooseAccountVCSegue", sender: self)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
