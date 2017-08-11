//
//  PPBankTransfeResumViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 29/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import MessageUI

var swipeColorBoxCenterX: CGFloat = 0.0

class PPBankTransfeResumViewController: UIViewController, MFMessageComposeViewControllerDelegate
{
    var sendMoney = SendMoney()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var superView: UIView!
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let status = sender.state.rawValue
        
        if let gestureView = sender.view {
            var newX = gestureView.center.x + translation.x
            
            if newX >= self.swipeBaseBox.center.x {
                newX = self.swipeBaseBox.center.x
            }
            
            if status == 3 {
                // if view displaced more or equal to 80% set complete 100%
                if self.swipeColorBox.center.x >= self.swipeBaseBox.center.x * 0.80 {
                    animateSwipe(position: self.swipeBaseBox.center.x)
//                    vibrateDevice()
                    goToConfirm()
                } else {
                    animateSwipe(position: swipeColorBoxCenterX)
                }
            } else {
                gestureView.center = CGPoint(x: newX, y: gestureView.center.y)
            }
        }
        
        sender.setTranslation(CGPoint.zero, in: sender.view)

    }
    @IBOutlet weak var swipeImage: UIImageView!
    @IBOutlet weak var swipeBaseBox: UIView!
    @IBOutlet weak var swipeColorBox: UIView!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var textInfo: UITextView!
    @IBOutlet weak var boxSwipe: UIView!
    @IBOutlet weak var boxActivityIndicator: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        swipeColorBoxCenterX = self.swipeColorBox.center.x
        
        self.amountLabel.text = sendMoney.getAmount()
        
        if sendMoney.getOperationType() == 0 {
            self.firstLabel.text = sendMoney.getForename()+" "+sendMoney.getLastname()
            
            if sendMoney.getAccountDetailsType() == 0 {
                self.secondLabel.text = sendMoney.getAccountNumber()+" "+sendMoney.getShortcode()
            } else if sendMoney.getAccountDetailsType() == 1 {
                self.secondLabel.text = sendMoney.getIban()+" "+sendMoney.getBic()
            }
            
            self.thirdLabel.text = sendMoney.getMessage()
            
            if sendMoney.getReason() == "Other" {
                self.fourthLabel.text = sendMoney.getReason()+": "+sendMoney.getReasonExplain()
            } else {
                self.fourthLabel.text = sendMoney.getReason()
            }
            
            self.textInfo.text = "Cell description which explains the consequences of the above action."
            
        } else if sendMoney.getOperationType() == 1 {
            self.amountLabel.text = sendMoney.getAmount()
            self.firstLabel.text = sendMoney.getBeneficiaryName()
            self.secondLabel.text = sendMoney.getMessage()
            self.textInfo.text = "Cell description which explains the consequences of the above action."
            
        } else if sendMoney.getOperationType() == 2 {
            self.amountLabel.text = sendMoney.getAmount()
            self.firstLabel.text = sendMoney.getBeneficiaryName()
            self.secondLabel.text = sendMoney.getMessage()
            self.thirdLabel.text = sendMoney.getphoneNumber()
            self.textInfo.text = "Cell description which explains the consequences of the above action DIF."
        }
        
        let amountBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let amountLayerTop = CAShapeLayer()
        amountLayerTop.path = amountBorderTop.cgPath
        amountLayerTop.fillColor = PayProColors.line.cgColor
        self.amountView.layer.addSublayer(amountLayerTop)
        
        let amountBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 105.6, width: self.view.frame.width, height: 0.4))
        let amountLayerBottom = CAShapeLayer()
        amountLayerBottom.path = amountBorderBottom.cgPath
        amountLayerBottom.fillColor = PayProColors.line.cgColor
        self.amountView.layer.addSublayer(amountLayerBottom)
        
        let infoBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let infoLayerTop = CAShapeLayer()
        infoLayerTop.path = infoBorderTop.cgPath
        infoLayerTop.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerTop)
        
        let infoBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 98.6, width: self.view.frame.width, height: 0.4))
        let infoLayerBottom = CAShapeLayer()
        infoLayerBottom.path = infoBorderBottom.cgPath
        infoLayerBottom.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerBottom)
        
        let a = String(sendMoney.getAmount())?.replacingOccurrences(of: "[^\\d+\\.?\\d+?]", with: "", options: [.regularExpression])
        
        print("a: \(a)")
        print("pennies: \(a?.getPennies())")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateSwipe(position: CGFloat)
    {
        UIView.animate(withDuration: 0.2) {
            self.swipeColorBox.center = CGPoint(x: CGFloat(position), y: self.swipeColorBox.center.y)
        }
    }
    
    func vibrateDevice()
    {
        AudioServicesPlaySystemSound(SystemSoundID (kSystemSoundID_Vibrate))
    }
    
    func showActivityIndicator()
    {
        activityIndicator.center = self.boxActivityIndicator.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.boxActivityIndicator.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func hideActivityIndicator()
    {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func goToConfirm()
    {
        if sendMoney.getOperationType() == 0 || sendMoney.getOperationType() == 1 {
            
            //call endpoint
            showActivityIndicator()
            
            createTransaction(completion:{createTransactionResponse in
                self.hideActivityIndicator()
                
                if createTransactionResponse {
                    let confirmViewController = PPSendMoneyConfirmViewController()
                    confirmViewController.modalTransitionStyle = .crossDissolve
                    confirmViewController.sendMoney = self.sendMoney
                    self.present(confirmViewController, animated: true, completion: {
                        self.tabBarController?.selectedIndex = 3
                        self.vibrateDevice()
                    })
                }
            })
            
        } else if sendMoney.getOperationType() == 2 {
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = "Enric Giribet te invita a que descarges PayPro App!!! http://www.payproapp.com "
                controller.recipients = ["666395251"]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            } else {
                print("no puedo enviar SMS!!")
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.sendMoney.setLoadProcess(loadProcessValue: 0)
        
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            animateSwipe(position: swipeColorBoxCenterX)
            self.dismiss(animated: true, completion: {
                let alert = UIAlertController(title: "iMessage Cancelled", message: "Swipe against and send imessage for complete invite send money", preferredStyle: UIAlertControllerStyle.alert)
                let confirmAction = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(confirmAction)
                
                self.present(alert, animated: true, completion: nil)
            })
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            animateSwipe(position: swipeColorBoxCenterX)
            self.dismiss(animated: true, completion: {
                let alert = UIAlertController(title: "iMessage Failed", message: "Swipe against and send imessage for complete invite send money", preferredStyle: UIAlertControllerStyle.alert)
                let confirmAction = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(confirmAction)
                
                self.present(alert, animated: true, completion: nil)
            })
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: {
                let confirmViewController = PPSendMoneyConfirmViewController()
                confirmViewController.modalTransitionStyle = .crossDissolve
                confirmViewController.sendMoney = self.sendMoney
                self.present(confirmViewController, animated: true, completion: {
                    self.vibrateDevice()
                    self.tabBarController?.selectedIndex = 3
                })
            })

        default:
            break;
        }
    }
    
    func createTransaction(completion: @escaping (_ createTransactionResponse: Bool) -> Void)
    {
        let amount = String(sendMoney.getAmount())?.replacingOccurrences(of: "[^\\d+\\.?\\d+?]", with: "", options: [.regularExpression])
        let transactionDictionary = [
            "beneficiary": String(sendMoney.getcontactId()),
            "amount": amount?.getPennies() as Any,
            "subject": String(sendMoney.getMessage())!
        ] as [String : Any]

        TransactionCreate(
            transaction: transactionDictionary as NSDictionary,
            completion: {transactionResponse in
                
                print("transaction: \(transactionResponse)")
                
                if transactionResponse["status"] as! Bool == true {
                    completion(true)
                } else if transactionResponse["errorMessage"] != nil {
                    self.animateSwipe(position: swipeColorBoxCenterX)
                    
                    let errorMessage: String = transactionResponse["errorMessage"] as! String
                    
                    let alert = UIAlertController()
                    
                    self.present(alert.displayAlert(code: errorMessage), animated: true, completion: nil)
                    
                    completion(false)
                    
                } else if transactionResponse["status"] as! Bool == false {
                    self.animateSwipe(position: swipeColorBoxCenterX)
                    
                    let alert = UIAlertController()
                    
                    self.present(alert.displayAlert(code: "transaction_failed"), animated: true, completion: nil)
                    
                    completion(false)
                }
            }
        )
    }
}

