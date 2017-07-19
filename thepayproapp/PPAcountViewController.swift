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
    
    var transactionsArray : [Transaction]?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        initDummyTransactions()
        
        transactionsTV.register(UINib(nibName: "PPTransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionCell")
        
        transactionsTV.reloadData()
        
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
    
    func initDummyTransactions()
    {
        transactionsArray = [Transaction]()
        
        var currentDictionary = [
            "id": Int64(0),
            "title": "Residencial Viella Sa",
            "subtitle": "Barcelona, Catalonia",
            "datetime": "2 days ago",
            "amount": Float(123.40)
            ] as [String : Any]
        
        var currentTransaction = Transaction.manage(transactionDictionary: currentDictionary as NSDictionary)
        transactionsArray?.append(currentTransaction!)
        
        currentDictionary = [
            "id": Int64(1),
            "title": "Pret A Manger Gatwik",
            "subtitle": "Barcelona, Catalonia",
            "datetime": "3 days ago",
            "amount": Float(-68.25)
            ] as [String : Any]
        
        currentTransaction = Transaction.manage(transactionDictionary: currentDictionary as NSDictionary)
        transactionsArray?.append(currentTransaction!)
        
        currentDictionary = [
            "id": Int64(2),
            "title": "W H Smith",
            "subtitle": "London, United Kingdom",
            "datetime": "5 days ago",
            "amount": Float(345.20)
            ] as [String : Any]
        
        currentTransaction = Transaction.manage(transactionDictionary: currentDictionary as NSDictionary)
        transactionsArray?.append(currentTransaction!)
        
        currentDictionary = [
            "id": Int64(3),
            "title": "Marks & Spencer-Kensington High Street",
            "subtitle": "London, United Kingdom",
            "datetime": "8 days ago",
            "amount": Float(64.70)
            ] as [String : Any]
        
        currentTransaction = Transaction.manage(transactionDictionary: currentDictionary as NSDictionary)
        transactionsArray?.append(currentTransaction!)
    }
    
    func setupView()
    {
        scrollView.contentOffset = CGPoint(x: accountDetailsView.bounds.width, y: 0.0)
        
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
    }
    
    @IBAction func cardButtonTouched(_ sender: Any)
    {
        let cardStatus = User.currentUser()?.cardStatus
        
        if cardStatus == .notOrdered
        {
            performSegue(withIdentifier: "showAddressFormVC", sender: self)
        }
        else if cardStatus == .ordered
        {
            self.performSegue(withIdentifier: "showActivateCardVCSegue", sender: nil)
        }
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showAddressFormVC"
        {
            let formVC = segue.destination as! PPCardSecondFormViewController
            formVC.orderingCard = true
        }
    }
}
