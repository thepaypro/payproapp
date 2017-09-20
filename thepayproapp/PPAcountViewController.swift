//
//  AccountViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 13/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPAccountViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cardIV: UIImageView!
    @IBOutlet weak var transactionsTV: UITableView!
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var cardHeight: NSLayoutConstraint!
    @IBOutlet weak var latestTransactionsView: UIView!
    @IBOutlet weak var accountDetailsView: UIView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var sortCodeLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var transactionsSegment: UIView!
    @IBOutlet weak var infoSegment: UIView!
    @IBOutlet weak var infoGbpAccountView: UIView!
    @IBOutlet weak var infoAccountNumberView: UIView!
    @IBOutlet weak var infoAccountSortCodeView: UIView!
    @IBOutlet weak var infoAccountNumberLabel: UILabel!
    @IBOutlet weak var infoAccountSortCodeLabel: UILabel!
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            transactionsSegment.isHidden = true
            infoSegment.isHidden = false
        case 1:
            transactionsSegment.isHidden = false
            infoSegment.isHidden = true
        default:
            break;
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
        
        let user = User.currentUser()
        
        self.navigationItem.title = User.currentUser()?.accountType == .proAccount ? "Pro account" : "Basic account"
        
        transactionsTV.register(UINib(nibName: "PPTransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionCell")
        
        refreshTransactionList(fullMode: false)
        
        self.transactionsTV.addSubview(self.refreshControl)
        
        scrollView.delegate = self
        
        let borderTop = UIBezierPath(rect: CGRect(x: 0, y: 0.4, width: UIScreen.main.bounds.width, height: 0.4))
        let layerTop = CAShapeLayer()
        layerTop.path = borderTop.cgPath
        layerTop.fillColor = UIColor.lightGray.cgColor
        latestTransactionsView.layer.addSublayer(layerTop)
        
        let borderTopTransactionsTV = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.40))
        let layerTopTransactionsTV = CAShapeLayer()
        layerTopTransactionsTV.path = borderTopTransactionsTV.cgPath
        layerTopTransactionsTV.fillColor = PayProColors.line.cgColor
        self.transactionsTV.layer.addSublayer(layerTopTransactionsTV)
        
        let borderTopinfoGbpAccountView = UIBezierPath(rect: CGRect(x: 0, y: 0.4, width: UIScreen.main.bounds.width, height: 0.4))
        let layerTopinfoGbpAccountView = CAShapeLayer()
        layerTopinfoGbpAccountView.path = borderTopinfoGbpAccountView.cgPath
        layerTopinfoGbpAccountView.fillColor = UIColor.lightGray.cgColor
        infoGbpAccountView.layer.addSublayer(layerTopinfoGbpAccountView)
        
        let borderTopInfo = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.40))
        let layerTopInfo = CAShapeLayer()
        layerTopInfo.path = borderTopInfo.cgPath
        layerTopInfo.fillColor = PayProColors.line.cgColor
        self.infoAccountNumberView.layer.addSublayer(layerTopInfo)
        
        let borderMiddleInfo = UIBezierPath(rect: CGRect(x: 15, y: 42.6, width: self.view.frame.width, height: 0.40))
        let layerMiddleInfo = CAShapeLayer()
        layerMiddleInfo.path = borderMiddleInfo.cgPath
        layerMiddleInfo.fillColor = PayProColors.line.cgColor
        self.infoAccountNumberView.layer.addSublayer(layerMiddleInfo)
        
        let borderBottomInfo = UIBezierPath(rect: CGRect(x: 0, y: 41.6, width: self.view.frame.width, height: 0.40))
        let layerBottomInfo = CAShapeLayer()
        layerBottomInfo.path = borderBottomInfo.cgPath
        layerBottomInfo.fillColor = PayProColors.line.cgColor
        self.infoAccountSortCodeView.layer.addSublayer(layerBottomInfo)
        
        self.accountLabel.text = user?.accountNumber
        self.sortCodeLabel.text = user?.sortCode
        self.balanceLabel.text = user?.amountBalance
        self.balanceLabel.numberOfLines = 1
        self.balanceLabel.adjustsFontSizeToFitWidth = true
        
        self.infoAccountNumberLabel.text = user?.accountNumber
        self.infoAccountSortCodeLabel.text = user?.sortCode
        
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
                    self.balanceLabel.text = accountGetBalanceResponse["balance"] as? String
                }
            }
        })
    }
    
    override func viewDidLayoutSubviews()
    {
        scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
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
        scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        
        cardButton.isHidden = false
        cardHeight.constant = 60.0
        
        let cardStatus = User.currentUser()?.cardStatus
        
        cardIV.image = UIImage(named: "account-card")
        
        if cardStatus == .notOrdered
        {
            cardButton.setTitle("Order Visa Debit Card", for: .normal)
        }
        else if cardStatus == .ordered
        {
            cardButton.setTitle("Activate Visa Debit Card", for: .normal)
            
            cardIV.image = UIImage(named: "account-card-pending")
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
