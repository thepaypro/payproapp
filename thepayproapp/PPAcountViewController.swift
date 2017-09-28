//
//  AccountViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 13/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
//    @IBOutlet weak var cardIV: UIImageView!
    @IBOutlet weak var transactionsTV: UITableView!
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var cardHeight: NSLayoutConstraint!
    @IBOutlet weak var latestTransactionsView: UIView!
    @IBOutlet weak var accountDetailsView: UIView!
//    @IBOutlet weak var accountLabel: UILabel!
//    @IBOutlet weak var sortCodeLabel: UILabel!
//    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var bitsView: UIView!
    @IBOutlet weak var GBPView: UIView!
    @IBOutlet weak var swipeCurrencyView: UIView!
    
    @IBAction func onSwipeAccount(_ sender: Any) {
        let yGBPView = GBPView.center.y
        let ybitsView = bitsView.center.y
        let GBPOnTop: Bool = yGBPView > ybitsView
        
        //swipeCurrencyView.bringSubview(toFront: GBPOnTop ? GBPView: bitsView)
        
        
        UIView.animate(withDuration: 0.5) {
            self.GBPView.center.y = ybitsView
            self.bitsView.center.y = yGBPView
            
            self.GBPView.subviews.forEach{ label in
                label.transform = CGAffineTransform(scaleX: GBPOnTop ? 0.5:1, y: GBPOnTop ? 0.5:1)
            }
            self.bitsView.subviews.forEach{ label in
                label.transform = CGAffineTransform(scaleX: GBPOnTop ? 1:0.5, y: GBPOnTop ? 1:0.5)
            }
            
            // create a CGPath that implements an arcs
//            let thePath: CGMutablePath  = CGMutablePath();
//            CGPathMoveToPoint(thePath,NULL,74.0,74.0);
//            CGPathAddArc(thePath, NULL, 0, 15, 15, M_PI_2, -M_PI_2, true);
//            GBPView.path = thePath
            
        }
    }
    var transactionsArray : [Transaction]?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.tintColor = PayProColors.blue
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let yGBPView = GBPView.center.y
        let ybitsView = bitsView.center.y
        let GBPOnTop: Bool = yGBPView > ybitsView
        self.GBPView.subviews.forEach{ label in
            label.transform = CGAffineTransform(scaleX: GBPOnTop ? 0.5:1, y: GBPOnTop ? 0.5:1)
        }
        self.bitsView.subviews.forEach{ label in
            label.transform = CGAffineTransform(scaleX: GBPOnTop ? 1:0.5, y: GBPOnTop ? 1:0.5)
        }
        
        let user = User.currentUser()
        
        self.navigationItem.title = User.currentUser()?.accountType == .proAccount ? "Pro account" : "Basic account"
        
        transactionsTV.register(UINib(nibName: "PPTransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionCell")
        
        refreshTransactionList(fullMode: false)
        
        self.transactionsTV.addSubview(self.refreshControl)
        
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
        
//        self.accountLabel.text = user?.accountNumber
//        self.sortCodeLabel.text = user?.sortCode
//        self.balanceLabel.text = user?.amountBalance
//        self.balanceLabel.numberOfLines = 1
//        self.balanceLabel.adjustsFontSizeToFitWidth = true
        
//        self.getBalance()
        
        self.setupView()
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
    
    func getBalance()
    {
        AccountGetBalance(completion: {accountGetBalanceResponse in
            if accountGetBalanceResponse["status"] as! Bool == true {
                    
                if accountGetBalanceResponse["balance"] != nil {
//                    self.balanceLabel.text = accountGetBalanceResponse["balance"] as? String
                }
            }
        })
    }
    
    func getTransactionsFromBack()
    {
        TransactionGetTransactions(completion: {transactionsResponse in
            print("transactionsResponse: \(transactionsResponse)")
            self.transactionsArray = Transaction.getTransactions()
        })
    }
    
    func getTransactions(){
        self.transactionsArray = Transaction.getTransactions()
    }
    
    func refreshTransactionList(fullMode:Bool)
    {
        getBalance()
        if fullMode == false {
            getTransactions()
        } else {
            getTransactionsFromBack()
        }
        self.transactionsTV.reloadData()
    }
    
    func setupView()
    {
        
        cardButton.isHidden = false
        cardHeight.constant = 60.0
        
        let cardStatus = User.currentUser()?.cardStatus
        
//        cardIV.image = UIImage(named: "account-card")
        
        if cardStatus == .notOrdered
        {
            cardButton.setTitle("Order Visa Debit Card", for: .normal)
        }
        else if cardStatus == .ordered
        {
            cardButton.setTitle("Activate Visa Debit Card", for: .normal)
            
//            cardIV.image = UIImage(named: "account-card-pending")
        }
        else
        {
            cardButton.isHidden = true
            cardHeight.constant = 0.0
        }
        
        refreshTransactionList(fullMode: false)
    }
    
    @IBAction func cardButtonTouched(_ sender: Any)
    {
        let cardStatus = User.currentUser()?.cardStatus
        
        if cardStatus == .notOrdered
        {
            self.performSegue(withIdentifier: "showShippingAddressVC", sender: self)
        }
        else if cardStatus == .ordered
        {
            self.performSegue(withIdentifier: "showActivateCardFormVCSegue", sender: self)
        }
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshTransactionList(fullMode: true)
        refreshControl.endRefreshing()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return transactionsArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! PPTransactionTableViewCell
        
        let cellTransaction = transactionsArray?[indexPath.row]
        
        cell.setTransaction(transaction: cellTransaction!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 76.0
    }
}
