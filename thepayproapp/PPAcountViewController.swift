//
//  AccountViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 13/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPAccountViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, CAAnimationDelegate
{
    //    @IBOutlet weak var cardIV: UIImageView!
    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var transactionsTV: UITableView!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var stateButtonHeight: NSLayoutConstraint!
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
    
    var isPositionFixed: Bool = true
     enum AccountCurrencyType: Int{
        case gbp = 0
        case bitcoin = 1
    }
    var selectedAccount: AccountCurrencyType = .gbp
    
//    var cardStatus: User.CardStatus = (User.currentUser()?.cardStatus)!
//    var userStatus: User.Status = .statusActivating
//    var userAccountType: User.AccountType = (User.currentUser()?.accountType)!
    
    var cardStatus: User.CardStatus = (User.currentUser()?.cardStatus)!
    var userStatus: User.Status = (User.currentUser()?.status)!
    var userAccountType: User.AccountType = (User.currentUser()?.accountType)!
    
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
    var transactionsNewFetchBool: Bool = false
    var transactionPageSize: Int = 5
    
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
        
        if userAccountType == .basicAccount {
            self.navigationItem.title = "Basic Account"
        }else if userAccountType == .proAccount  {
            self.navigationItem.title = "Pro Account"
        }else{
            self.navigationItem.title = "Demo Account"
        }
        
        transactionsTV.register(UINib(nibName: "PPTransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionCell")
        transactionsTV.register(UINib(nibName: "RefreshCellView", bundle: nil), forCellReuseIdentifier: "RefreshCell")
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
            if selectedAccount == .bitcoin { transactionsTV.isHidden = false }
            self.getBalance()
            if userStatus == .statusActivated || selectedAccount == .bitcoin {
                self.loadTransactions()
            }else if(userStatus != .statusActivated && selectedAccount == .gbp){
                transactionsTV.isHidden = true
            }
            isPositionFixed = true
            
        }
    }
    
    func getBalance()
    {
        if(userStatus == .statusActivated){
            AccountGetBalance(completion: {accountGetBalanceResponse in
                if accountGetBalanceResponse["status"] as! Bool == true {
                    if accountGetBalanceResponse["balance"] != nil {
//                        print("updatingGBPBalance")
                        self.GBPBalanceLabel.text = accountGetBalanceResponse["balance"] as? String
                    }
                }
            })
        }
        BitcoinGetWallet(completion: {bitcoinWalletResponse in
            if bitcoinWalletResponse["status"] as! Bool == true {
                if bitcoinWalletResponse["balance"] != nil{
//                    print("updatingBTCBalance")
                    self.bitsBalanceLabel.text = bitcoinWalletResponse["balance"] as? String
                }
            }
        })
    }
    
    func loadTransactions(){
        switch selectedAccount {
            case .gbp:
                self.transactionsArray = Transaction.getTransactions()
                transactionsTV.reloadData()
            case .bitcoin:
                self.bitcointransactionsArray = BitcoinTransaction.getTransactions()
                transactionsTV.reloadData()
        }
    }
    
    func firstTimeSetup(){
        self.GBPResizableView.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.GBPResizableView.alpha = 0.7
        self.bitsResizableView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.bitsResizableView.alpha = 0.7
        
        if userStatus == .statusDemo {
            
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
    }
    
    func setupView(){
        
        cardStatus = (User.currentUser()?.cardStatus)!
        userStatus = (User.currentUser()?.status)!
        userAccountType = (User.currentUser()?.accountType)!
        
        
        if userStatus == .statusActivated {
            self.GBPBalanceLabel.text = User.currentUser()?.amountBalance
            self.GBPBalanceLabel.numberOfLines = 1
            self.GBPBalanceLabel.adjustsFontSizeToFitWidth = true
        }
        
        self.bitsBalanceLabel.text = User.currentUser()?.bitcoinAmountBalance
        self.bitsBalanceLabel.numberOfLines = 1
        self.bitsBalanceLabel.adjustsFontSizeToFitWidth = true
        self.getBalance()

        
        
        stateButton.isHidden = false
        stateButtonHeight.constant = 60.0
        
        self.setSelectedAccountInfoLabels()
        
        if (userStatus == .statusDemo || userAccountType == .demoAccount || userStatus == .statusActivated) && (selectedAccount == .gbp){
            transactionsTV.isHidden = true
        }
        
        if userStatus == .statusDemo {
            stateButton.setTitle("Start Now", for: .normal)
        }
        else if userAccountType == .demoAccount || userStatus == .statusActivating{
            stateButton.setTitle("Your account is being reviewed", for: .normal)
            stateButton.isEnabled = false
            stateButton.backgroundColor = PayProColors.statusButtonInactive
            stateButton.setTitleColor(PayProColors.statusButtonInactiveText, for: .normal)
        }
        else if cardStatus == .notOrdered
        {
            stateButton.setTitle("Order Visa Debit Card", for: .normal)
        }
        else if cardStatus == .ordered
        {
            stateButton.setTitle("Activate Visa Debit Card", for: .normal)
        }
        else
        {
            stateButton.isHidden = true
            stateButtonHeight.constant = 0.0
        }
        
        loadTransactions()
    }
    
    func setSelectedAccountInfoLabels() {
        
        switch selectedAccount {
        case .gbp:
            self.infoTitleLabel.text = "GBP ACCOUNT"
            self.infoAccountNumberLabel.text = (userStatus == .statusActivated) ? User.currentUser()?.accountNumber : "-"
            self.infoAccountSortCodeLabel.text = (userStatus == .statusActivated) ? User.currentUser()?.sortCode : "-"
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
    
    @IBAction func stateButtonTouched(_ sender: Any)
    {
        
        if userStatus == .statusDemo{
            self.performSegue(withIdentifier: "showChooseAccountVCSegue", sender: self)
        }
        else if userStatus == .statusActivating{
            // do nothing
        }
        else if cardStatus == .notOrdered
        {
            self.performSegue(withIdentifier: "showShippingAddressVC", sender: self)
        }
        else if cardStatus == .ordered
        {
            self.performSegue(withIdentifier: "showActivateCardFormVCSegue", sender: self)
        }
    }
    // MARK: - Table handle refresh
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        getBalance()
        refreshTransactionsFromBack(selectedAccount: selectedAccount ,completion: {refreshTransactionsFromBackResponse in
            if refreshTransactionsFromBackResponse["status"] as! Bool == true {
                self.selectedAccount == .bitcoin ? (self.bitcointransactionsArray = BitcoinTransaction.getTransactions()): (self.transactionsArray = Transaction.getTransactions())
                self.transactionsTV.reloadData()
                self.refreshControl.endRefreshing()
            }else{
                
            }
        })
    }
    
    //MARK:- ScrollView Delegate
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if(decelerate && transactionsNewFetchBool && scrollView.contentOffset.y >= 0)
        {
            let tv =  scrollView as! UITableView
            let lastCellIndexPath = IndexPath(row: transactionsTV.numberOfRows(inSection: 0) - 1 , section: 0)
            if let refreshCell = tv.cellForRow(at: lastCellIndexPath) as? RefreshCellView{
                refreshCell.showLoader()
                let reloadPreviousPage = (selectedAccount == .bitcoin) ? ((bitcointransactionsArray?.count)! % transactionPageSize > 0) : ((transactionsArray?.count)! % transactionPageSize > 0)
                    getTransactionsFromBack(selectedAccount: selectedAccount, reloadPreviousPage: reloadPreviousPage, completion: {getTransactionsFromBackResponse in
                        if getTransactionsFromBackResponse["status"] as! Bool == true {
                            self.selectedAccount == .bitcoin ? (self.bitcointransactionsArray = BitcoinTransaction.getTransactions()): (self.transactionsArray = Transaction.getTransactions())
                            self.transactionsTV.reloadData()
                        }else{
                            //show alert
                        }
                    })
                transactionsNewFetchBool = false
            }
        }
        else if(!decelerate)
        {
            transactionsNewFetchBool = false
        }
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
//            print(transactionsArray?.count)
            return transactionsArray!.count + 1
        case .bitcoin:
//            print(bitcointransactionsArray?.count)
            return bitcointransactionsArray!.count + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (indexPath as NSIndexPath).row < (selectedAccount == .bitcoin ? bitcointransactionsArray?.count : transactionsArray?.count)!{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! PPTransactionTableViewCell
            let cellTransaction = (selectedAccount == .bitcoin ? bitcointransactionsArray?[indexPath.row] : transactionsArray?[indexPath.row])
            selectedAccount == .bitcoin ? cell.setBitcoinTransaction(transaction: cellTransaction! as! BitcoinTransaction) : cell.setTransaction(transaction: cellTransaction! as! Transaction)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RefreshCell") as! RefreshCellView
            cell.hideLoader()
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
            return 76.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        transactionsNewFetchBool = false
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        transactionsNewFetchBool = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQRCode" {
            let showQRCodeVC : PPShowQRCode = segue.destination as! PPShowQRCode
            showQRCodeVC.dataToQR = "bitcoin:" + (User.currentUser()?.bitcoinAddress)!
        }
    }
    
}
