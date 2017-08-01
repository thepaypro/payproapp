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
        
        self.navigationItem.title = User.currentUser()?.accountType == .proAccount ? "Pro account" : "Basic account"
        
        transactionsTV.register(UINib(nibName: "PPTransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionCell")
        
        refreshTransactionList()
        
        self.transactionsTV.addSubview(self.refreshControl)
        
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
        
        self.accountLabel.text = User.currentUser()?.accountNumber
        self.sortCodeLabel.text = User.currentUser()?.sortCode
        self.balanceLabel.text = "£ 99,999.99"
        self.balanceLabel.numberOfLines = 1
        self.balanceLabel.adjustsFontSizeToFitWidth = true
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
        scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
    
    func getTransactions()
    {
        transactionsArray = Transaction.getTransactions()
    }
    
    func refreshTransactionList()
    {
        getTransactions()
        self.transactionsTV.reloadData()
    }
    
//    func initDummyTransactions()
//    {
//        transactionsArray = [Transaction]()
//        
//        var currentDictionary = [
//            "id": Int64(0),
//            "title": "Residencial Viella Sa",
//            "subtitle": "Barcelona, Catalonia",
//            "datetime": "2 days ago",
//            "amount": Float(123.40)
//            ] as [String : Any]
//        
//        var currentTransaction = Transaction.manage(transactionDictionary: currentDictionary as NSDictionary)
//        transactionsArray?.append(currentTransaction!)
//        
//        currentDictionary = [
//            "id": Int64(1),
//            "title": "Pret A Manger Gatwik",
//            "subtitle": "Barcelona, Catalonia",
//            "datetime": "3 days ago",
//            "amount": Float(-68.25)
//            ] as [String : Any]
//        
//        currentTransaction = Transaction.manage(transactionDictionary: currentDictionary as NSDictionary)
//        transactionsArray?.append(currentTransaction!)
//        
//        currentDictionary = [
//            "id": Int64(2),
//            "title": "W H Smith",
//            "subtitle": "London, United Kingdom",
//            "datetime": "5 days ago",
//            "amount": Float(345.20)
//            ] as [String : Any]
//        
//        currentTransaction = Transaction.manage(transactionDictionary: currentDictionary as NSDictionary)
//        transactionsArray?.append(currentTransaction!)
//        
//        currentDictionary = [
//            "id": Int64(3),
//            "title": "Marks & Spencer-Kensington High Street",
//            "subtitle": "London, United Kingdom",
//            "datetime": "8 days ago",
//            "amount": Float(64.70)
//            ] as [String : Any]
//        
//        currentTransaction = Transaction.manage(transactionDictionary: currentDictionary as NSDictionary)
//        transactionsArray?.append(currentTransaction!)
//    }
    
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
        
        refreshTransactionList()
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
            self.performSegue(withIdentifier: "showActivateCardVCSegue", sender: nil)
        }
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
//        let newMovie = Movie(title: "Serenity", genre: "Sci-fi")
//        movies.append(newMovie)
//        
//        movies.sort() { $0.title < $1.title }
        
        refreshTransactionList()
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
