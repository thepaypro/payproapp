//
//  AccountViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 13/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CAAnimationDelegate
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
    @IBOutlet weak var bitsBalanceLabel: UILabel!
    @IBOutlet weak var GBPBalanceLabel: UILabel!
    
    @IBOutlet weak var bitsView: UIView!
    @IBOutlet weak var bitsResizableView: UIView!
    @IBOutlet weak var GBPView: UIView!
    @IBOutlet weak var GBPResizableView: UIView!
    @IBOutlet weak var swipeCurrencyView: UIView!
    var isPositionFixed: Bool = true
    
    @IBAction func swipeBitsViewLeft(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: bitsView, viewOneResizable: bitsResizableView, viewTwo: GBPView, viewTwoResizable: GBPResizableView, duration: Double(2), directionRight: false)
        }
    }
    @IBAction func swipeGBPViewLeft(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: GBPView, viewOneResizable: GBPResizableView, viewTwo: bitsView, viewTwoResizable: bitsResizableView, duration: Double(2), directionRight: false)
        }
    }
    @IBAction func swipeGBPViewRight(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: GBPView, viewOneResizable: GBPResizableView, viewTwo: bitsView, viewTwoResizable: bitsResizableView, duration: Double(2), directionRight: true)
        }
    }
    @IBAction func swipeBitsViewRight(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: bitsView, viewOneResizable: bitsResizableView, viewTwo: GBPView, viewTwoResizable: GBPResizableView, duration: Double(2), directionRight: true)
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
        
        //Do any additional setup after loading the view.
//        self.GBPView.subviews.forEach{ label in
//            label.transform = CGAffineTransform(scaleX: 1, y: 1)
//            label.alpha = 1
//        }
//        self.bitsView.subviews.forEach{ label in
//            label.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//            label.alpha = 0.7
//        }
        GBPResizableView.transform = CGAffineTransform(scaleX: 1, y: 1)
        GBPResizableView.alpha = 0.7
        bitsResizableView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        bitsResizableView.alpha = 0.7
        
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
        
        
        self.GBPBalanceLabel.text = user?.amountBalance
        self.GBPBalanceLabel.numberOfLines = 1
        self.GBPBalanceLabel.adjustsFontSizeToFitWidth = true
        
        self.bitsBalanceLabel.text = "bits 123.45"
        self.bitsBalanceLabel.numberOfLines = 1
        self.bitsBalanceLabel.adjustsFontSizeToFitWidth = true
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
    
    fileprivate func setCurrencyAnimation(viewOne: UIView, viewOneResizable: UIView ,viewTwo: UIView, viewTwoResizable: UIView, duration: Double, directionRight: Bool) {
        isPositionFixed = false
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        let xviewOne = viewOne.center.x
        let yviewOne = viewOne.center.y
        let yviewTwo = viewTwo.center.y
        let viewOneOnTop: Bool = yviewOne < yviewTwo
        
        let pathOne: CGMutablePath  = CGMutablePath();
        let pathTwo: CGMutablePath  = CGMutablePath();
        let arcHeight = abs(yviewOne - yviewTwo)
        let arcCenter = CGPoint(x: xviewOne , y: yviewOne + (viewOneOnTop ? arcHeight/2 : -arcHeight/2));
        let angleOne = viewOneOnTop ? -CGFloat.pi/2 : CGFloat.pi/2
        let angleTwo = viewOneOnTop ? CGFloat.pi/2 : -CGFloat.pi/2

        
        pathOne.addArc(center: arcCenter, radius: arcHeight/2 ,startAngle: angleOne, endAngle: angleTwo, clockwise: viewOneOnTop ? (directionRight ?  false : true ) : (directionRight ?  true : false ))
        pathTwo.addArc(center: arcCenter, radius: arcHeight/2 ,startAngle: angleTwo, endAngle: angleOne, clockwise: viewOneOnTop ? (directionRight ?  false : true ) : (directionRight ?  true : false ))
        
        animation.path = pathOne
        animation.duration = duration
        animation.isCumulative = true;
        animation.isRemovedOnCompletion = false;
        animation.fillMode = kCAFillModeForwards
        animation.delegate = self
        
        viewOne.layer.add(animation, forKey: "move currency indicators along path")
        
        animation.path = pathTwo
        viewTwo.layer.add(animation, forKey: "move currency indicators along path")
        
        UIView.animate(withDuration: duration) {
            
            viewOneResizable.transform = CGAffineTransform(scaleX: viewOneOnTop ? 1:0.5, y: viewOneOnTop ? 1:0.5)
            viewOneResizable.alpha = 0.7
//            viewOne.subviews.forEach{ label in
//                label.transform = CGAffineTransform(scaleX: viewOneOnTop ? 1:0.5, y: viewOneOnTop ? 1:0.5)
//                label.alpha = viewOneOnTop ? 1:0.7
//            }
            viewTwoResizable.transform = CGAffineTransform(scaleX: viewOneOnTop ? 0.5:1, y: viewOneOnTop ? 0.5:1)
            viewTwoResizable.alpha = 0.7
//            viewTwo.subviews.forEach{ label in
//                label.transform = CGAffineTransform(scaleX: viewOneOnTop ? 0.5:1, y: viewOneOnTop ? 0.5:1)
//                label.alpha = viewOneOnTop ? 0.7:1
//            }
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if !isPositionFixed {
            let bitsViewy = bitsView.center.y
            let GBPViewy = GBPView.center.y
            GBPView.center.y = bitsViewy
            bitsView.center.y = GBPViewy
            isPositionFixed = true
        }else{
            isPositionFixed = true
        }
    }
    
    func getBalance()
    {
        AccountGetBalance(completion: {accountGetBalanceResponse in
            if accountGetBalanceResponse["status"] as! Bool == true {
                    
                if accountGetBalanceResponse["balance"] != nil {
//                    self.balanceLabel.text = accountGetBalanceResponse["balance"] as? String
                    self.GBPBalanceLabel.text = accountGetBalanceResponse["balance"] as? String
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
