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
    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var transactionsTV: UITableView!
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var cardHeight: NSLayoutConstraint!
    @IBOutlet weak var latestTransactionsView: UIView!
    @IBOutlet weak var bitsBalanceLabel: UILabel!
    @IBOutlet weak var GBPBalanceLabel: UILabel!
    @IBOutlet weak var bitsView: UIView!
    @IBOutlet weak var bitsResizableView: UIView!
    @IBOutlet weak var GBPView: UIView!
    @IBOutlet weak var GBPResizableView: UIView!
    @IBOutlet weak var transactionsSegment: UIView!
    @IBOutlet weak var infoSegment: UIView!
    @IBOutlet weak var infoGbpAccountView: UIView!
    @IBOutlet weak var infoAccountNumberView: UIView!
    @IBOutlet weak var infoAccountNumberLabel: UILabel!
    @IBOutlet weak var infoAccountSortCodeView: UIView!
    @IBOutlet weak var infoAccountSortCodeLabel: UILabel!
    @IBOutlet weak var infoAccountQRCodeView: UIView!
    @IBOutlet weak var swipeCurrencyGradientView: UIView!
    
    @IBAction func infoAccountQRCodeButton(_ sender: Any) {
        //self.performSegue(withIdentifier: String, sender: <#T##Any?#>)
    }
    
    var isPositionFixed: Bool = true
    enum AccountCurrencyType: Int{
        case gbp = 0
        case bitcoin = 1
    }
    var selectedAccount: AccountCurrencyType = .gbp
    
    @IBAction func swipeBitsViewLeft(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: bitsView, viewOneResizable: bitsResizableView, viewTwo: GBPView, viewTwoResizable: GBPResizableView, duration: Double(1.2), directionRight: false)
        }
    }
    @IBAction func swipeGBPViewLeft(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: GBPView, viewOneResizable: GBPResizableView, viewTwo: bitsView, viewTwoResizable: bitsResizableView, duration: Double(1.2), directionRight: false)
        }
    }
    @IBAction func swipeGBPViewRight(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: GBPView, viewOneResizable: GBPResizableView, viewTwo: bitsView, viewTwoResizable: bitsResizableView, duration: Double(1.2), directionRight: true)
        }
    }
    @IBAction func swipeBitsViewRight(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: bitsView, viewOneResizable: bitsResizableView, viewTwo: GBPView, viewTwoResizable: GBPResizableView, duration: Double(1.2), directionRight: true)
        }
    }
    @IBAction func swipeBitsViewDown(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: bitsView, viewOneResizable: bitsResizableView, viewTwo: GBPView, viewTwoResizable: GBPResizableView, duration: Double(1.2), directionRight: false)
        }
    }
    @IBAction func swipeBitsViewUp(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: bitsView, viewOneResizable: bitsResizableView, viewTwo: GBPView, viewTwoResizable: GBPResizableView, duration: Double(1.2), directionRight: true)
        }
    }
    @IBAction func swipeGBPViewDown(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: GBPView, viewOneResizable: GBPResizableView, viewTwo: bitsView, viewTwoResizable: bitsResizableView, duration: Double(1.2), directionRight: false)
        }
    }
    @IBAction func swipeGBPViewUp(_ sender: Any) {
        if isPositionFixed{
            setCurrencyAnimation(viewOne: GBPView, viewOneResizable: GBPResizableView, viewTwo: bitsView, viewTwoResizable: bitsResizableView, duration: Double(1.2), directionRight: true)
        }
    }
    
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
    var bitcointransactionsArray : [BitcoinTransaction]?
    
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
        
        self.firstTimeSetup()
        
        self.addGradient()
        
        self.navigationItem.title = User.currentUser()?.accountType == .proAccount ? "Pro account" : "Basic account"
        
        transactionsTV.register(UINib(nibName: "PPTransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionCell")
        
        self.transactionsTV.addSubview(self.refreshControl)
        
        self.addVisualLines()
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
            viewTwoResizable.transform = CGAffineTransform(scaleX: viewOneOnTop ? 0.5:1, y: viewOneOnTop ? 0.5:1)
            viewTwoResizable.alpha = 0.7
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if !isPositionFixed {
            let GBPViewy = GBPView.center.y
            GBPView.center.y = bitsView.center.y
            bitsView.center.y = GBPViewy
            selectedAccount = GBPView.center.y > bitsView.center.y ? .gbp : .bitcoin
            self.setSelectedAccountInfoLabels()
            self.getBalance()
            isPositionFixed = true
            self.refreshTransactionList(fullMode: false)
        }
    }
    
    func getBalance()
    {
//        get bitcoin balance as well
//        AccountGetBalance(completion: {accountGetBalanceResponse in
//            if accountGetBalanceResponse["status"] as! Bool == true {
//
//                if accountGetBalanceResponse["balance"] != nil {
//                    print("updatingBalance")
//                    self.GBPBalanceLabel.text = accountGetBalanceResponse["balance"] as? String
//                }
//            }
//        })
    }
    
    func getTransactionsFromBack()
    {
        switch selectedAccount {
        case .gbp:
            TransactionGetTransactions(completion: {transactionsResponse in
                print("transactionsResponse: \(transactionsResponse)")
                self.transactionsArray = Transaction.getTransactions()
            })
        case .bitcoin:
            BitcoinTransactionList(completion: {transactionsResponse in
                print("transactionsResponse: \(transactionsResponse)")
                self.bitcointransactionsArray = BitcoinTransaction.getTransactions()
            })
        }
    }
    
    func getTransactions(){
        switch selectedAccount {
            case .gbp:
                self.transactionsArray = Transaction.getTransactions()
            case .bitcoin:
                self.bitcointransactionsArray = BitcoinTransaction.getTransactions()
        }
        
    }
    
    func refreshTransactionList(fullMode:Bool)
    {
        // getBalance()
        if fullMode == false {
            getTransactions()
        } else {
            getTransactionsFromBack()
        }
        self.transactionsTV.reloadData()
    }
    
    func firstTimeSetup(){
        self.GBPResizableView.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.GBPResizableView.alpha = 0.7
        self.bitsResizableView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.bitsResizableView.alpha = 0.7
    }
    
    func setupView(){
        self.GBPBalanceLabel.text = User.currentUser()?.amountBalance
        self.getBalance()
        self.GBPBalanceLabel.numberOfLines = 1
        self.GBPBalanceLabel.adjustsFontSizeToFitWidth = true
        
        self.bitsBalanceLabel.text = User.currentUser()?.bitcoinAmountBalance
        self.bitsBalanceLabel.numberOfLines = 1
        self.bitsBalanceLabel.adjustsFontSizeToFitWidth = true
        
        cardButton.isHidden = false
        cardHeight.constant = 60.0
        
        self.setSelectedAccountInfoLabels()
        
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
        
        refreshTransactionList(fullMode: false)
    }
    
    func setSelectedAccountInfoLabels() {
        
        switch selectedAccount {
        case .gbp:
            self.infoTitleLabel.text = "GBP ACCOUNT"
            self.infoAccountNumberLabel.text = User.currentUser()?.accountNumber
            self.infoAccountSortCodeLabel.text = User.currentUser()?.sortCode
            self.infoAccountSortCodeView.isHidden = false
            self.infoAccountQRCodeView.isHidden = true
        case .bitcoin:
            self.infoTitleLabel.text = "BITCOIN ACCOUNT"
            self.infoAccountNumberLabel.text = User.currentUser()?.bitcoinAddress
            self.infoAccountSortCodeView.isHidden = true
            self.infoAccountQRCodeView.isHidden = false
        }
    }
    
    func addGradient(){
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = swipeCurrencyGradientView.bounds
        
        gradientLayer.colors = [PayProColors.blue.cgColor, PayProColors.gradientPink.cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.locations = [0.4,1]
        
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        swipeCurrencyGradientView.layer.addSublayer(gradientLayer)
    }
    
    func addVisualLines(){
        
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
        
        let borderMiddleInfo = UIBezierPath(rect: CGRect(x: 15, y: 41.6, width: self.view.frame.width, height: 0.40))
        let layerMiddleInfo = CAShapeLayer()
        layerMiddleInfo.path = borderMiddleInfo.cgPath
        layerMiddleInfo.fillColor = PayProColors.line.cgColor
        self.infoAccountNumberView.layer.addSublayer(layerMiddleInfo)
        
        let borderBottomInfo = UIBezierPath(rect: CGRect(x: 0, y: 41.6, width: self.view.frame.width, height: 0.40))
        let layerBottomInfo = CAShapeLayer()
        layerBottomInfo.path = borderBottomInfo.cgPath
        layerBottomInfo.fillColor = PayProColors.line.cgColor
        self.infoAccountSortCodeView.layer.addSublayer(layerBottomInfo)
        
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
        switch selectedAccount {
        case .gbp:
            return transactionsArray!.count
        case .bitcoin:
            return bitcointransactionsArray!.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! PPTransactionTableViewCell
        
        switch selectedAccount {
        case .gbp:
            let cellTransaction = transactionsArray?[indexPath.row]
            cell.setTransaction(transaction: cellTransaction!)
        case .bitcoin:
            let cellTransaction = bitcointransactionsArray?[indexPath.row]
            cell.setBitcoinTransaction(transaction: cellTransaction!)
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 76.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQRCode" {
            let showQRCodeVC : PPShowQRCode = segue.destination as! PPShowQRCode
            showQRCodeVC.dataToQR = "bitcoin:" + (User.currentUser()?.bitcoinAddress)!
        }
    }
}
