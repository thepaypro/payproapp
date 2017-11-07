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
    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var transactionsTV: UITableView!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var stateButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var latestTransactionsView: UIView!
    @IBOutlet weak var bitsBalanceLabel: UILabel!
    @IBOutlet weak var bitsView: UIView!
    @IBOutlet weak var bitsResizableView: UIView!
    @IBOutlet weak var transactionsSegment: UIView!
    @IBOutlet weak var infoSegment: UIView!
    @IBOutlet weak var infoGbpAccountView: UIView!
    @IBOutlet weak var infoAccountNumberView: UIView!
    @IBOutlet weak var infoAccountNumberLabel: UITextView!
    @IBOutlet weak var infoAccountQRCodeView: UIView!
    @IBOutlet weak var swipeCurrencyGradientView: UIView!
    @IBOutlet weak var bitcoinQRButton: UIButton!
    
    var isPositionFixed: Bool = true
    enum AccountCurrencyType: Int{
        case bitcoin = 1
    }
    var selectedAccount: AccountCurrencyType = .bitcoin
    
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
    
    var bitcointransactionsArray : [BitcoinTransaction]?
    var transactionsNewFetchBool: Bool = false
    var transactionPageSize: Int = 5
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.tintColor = PayProColors.blue
        refreshControl.backgroundColor = PayProColors.white
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Do any additional setup after loading the view.
        
        self.firstTimeSetup()
        
        self.addGradient()
        
        self.navigationItem.title = "Account"
        
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
    
    func loadTransactions(){
        switch selectedAccount {
        case .bitcoin:
            self.bitcointransactionsArray = BitcoinTransaction.getTransactions()
            transactionsTV.reloadData()
        }
    }
    
    func firstTimeSetup(){
        
    }
    
    func setupView(){
        
        self.setSelectedAccountInfoLabels()
        
        transactionsTV.isHidden = false
        loadTransactions()
        self.bitsBalanceLabel.text = User.currentUser()?.bitcoinAmountBalance
        self.bitsBalanceLabel.numberOfLines = 1
        self.bitsBalanceLabel.adjustsFontSizeToFitWidth = true
        
        stateButton.isHidden = true
        stateButtonHeight.constant = 0.0
        
    }
    
//    func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
//        if let lblFont = gesture.view as? UILabel {
//            UIPasteboard.general.string = lblFont.text
//        }
//    }
    
    func setSelectedAccountInfoLabels() {
        
        switch selectedAccount {
        case .bitcoin:
            self.infoTitleLabel.text = "BITCOIN ACCOUNT"
            self.infoAccountNumberLabel.text =  User.currentUser()?.bitcoinAddress
            self.infoAccountQRCodeView.isHidden = false
            self.bitcoinQRButton.isEnabled = true
        }
    }
    
    func addGradient(){
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.bitsView.frame.size.height)
        
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
        
    }
    
    @IBAction func stateButtonTouched(_ sender: Any)
    {
        self.performSegue(withIdentifier: "showChooseAccountVCSegue", sender: self)
    }
    // MARK: - Table handle refresh
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        AccountsInfo(completion: {response in
            if let bitcoinBalance = response["balance"], response["status"] as! Bool == true{
                self.bitsBalanceLabel.text = bitcoinBalance as? String
                self.bitcointransactionsArray = BitcoinTransaction.getTransactions()
                self.transactionsTV.reloadData()
                self.refreshControl.endRefreshing()
            }else if let errorMessage = response["errorMessage"] {
                let alert = UIAlertController()
                self.present(alert.displayAlert(code: errorMessage as! String), animated: true, completion: nil)
            }else{
                let alert = UIAlertController()
                self.present(alert.displayAlert(code: "unable_to_load_transactions"), animated: true, completion: nil)
            }
        });
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch selectedAccount {
        case .bitcoin:
            //          print(bitcointransactionsArray?.count)
            return bitcointransactionsArray!.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! PPTransactionTableViewCell
        let cellTransaction = bitcointransactionsArray?[indexPath.row]
        cell.setBitcoinTransaction(transaction: cellTransaction! as! BitcoinTransaction)
        return cell
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
