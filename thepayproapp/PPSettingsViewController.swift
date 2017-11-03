//
//  PPSettingsViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 13/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit
import MessageUI

class PPSettingsViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameArrow: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var cardView: UIView!
    
    @IBAction func tellButtonAction(_ sender: Any) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Hi! Just wanted to show you this new App called \"PayPro\", it works for sharing, sending and spending money with friends. It's on the AppStore!"
//            controller.recipients = ["666395251"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            print("no puedo enviar SMS!!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nameBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let nameLayerTop = CAShapeLayer()
        nameLayerTop.path = nameBorderTop.cgPath
        nameLayerTop.fillColor = PayProColors.line.cgColor
        self.nameView.layer.addSublayer(nameLayerTop)
        
        let nameBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 75.6, width: self.view.frame.width, height: 0.4))
        let nameLayerBottom = CAShapeLayer()
        nameLayerBottom.path = nameBorderBottom.cgPath
        nameLayerBottom.fillColor = PayProColors.line.cgColor
        self.nameView.layer.addSublayer(nameLayerBottom)
        
        let cardBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let cardLayerTop = CAShapeLayer()
        cardLayerTop.path = cardBorderTop.cgPath
        cardLayerTop.fillColor = PayProColors.line.cgColor
        self.cardView.layer.addSublayer(cardLayerTop)
        
        let cardBorderMiddle = UIBezierPath(rect: CGRect(x: 0, y: 43.6, width: self.view.frame.width, height: 0.4))
        let cardLayerMiddle = CAShapeLayer()
        cardLayerMiddle.path = cardBorderMiddle.cgPath
        cardLayerMiddle.fillColor = PayProColors.line.cgColor
        self.cardView.layer.addSublayer(cardLayerMiddle)
        
        
        let infoBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let infoLayerTop = CAShapeLayer()
        infoLayerTop.path = infoBorderTop.cgPath
        infoLayerTop.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerTop)
        
        let infoBorderMiddle = UIBezierPath(rect: CGRect(x: 58, y: 43.6, width: self.view.frame.width, height: 0.4))
        let infoLayerMiddle = CAShapeLayer()
        infoLayerMiddle.path = infoBorderMiddle.cgPath
        infoLayerMiddle.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerMiddle)
        
        let infoBorderMiddleB = UIBezierPath(rect: CGRect(x: 0, y: 87.6, width: self.view.frame.width, height: 0.4))
        let infoLayerMiddleB = CAShapeLayer()
        infoLayerMiddleB.path = infoBorderMiddleB.cgPath
        infoLayerMiddleB.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerMiddleB)
        
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupView()
    }
    
    func setupView()
    {
        //rounded avatar image
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width/2
        avatarImage.clipsToBounds = true
        
        var data:NSData?
        data = UserDefaults.standard.object(forKey: "avatar") as? NSData
        
        if data != nil
        {
            avatarImage.contentMode = .scaleToFill
            avatarImage.image = UIImage(data: data! as Data)
        } else {
            avatarImage.contentMode = .scaleToFill
            avatarImage.image = UIImage(named:"default-profile")
        }
        
        self.nameLabel.text = User.currentUser()?.nickname ?? "Nickname"
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            
            self.dismiss(animated: true, completion: {
                let alert = UIAlertController(title: "SMS Cancelled", message: "The message has been successfully canceled.", preferredStyle: UIAlertControllerStyle.alert)
                let confirmAction = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(confirmAction)
                
                self.present(alert, animated: true, completion: nil)
            })
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            
            self.dismiss(animated: true, completion: {
                let alert = UIAlertController(title: "Failed message", message: "Oops! Something went wrong, please try again. If you see the error persists, please contact us at \"Support\".", preferredStyle: UIAlertControllerStyle.alert)
                let confirmAction = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(confirmAction)
                
                self.present(alert, animated: true, completion: nil)
            })
        case MessageComposeResult.sent.rawValue:
            
            self.dismiss(animated: true, completion: {
                self.tabBarController?.selectedIndex = 3
            })
            
        default:
            break;
        }
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOldPasscodeSegue" {
            let changePasscodeVC : PPPasscodeViewController = segue.destination as! PPPasscodeViewController
            changePasscodeVC.changePassword = true
        }
    }
}

