//
//  PPSettingsViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 13/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPSettingsViewController: UIViewController {

    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var upgradeView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameArrow: UIImageView!
    @IBOutlet weak var disableCardSwitch: UISwitch!
    
    @IBAction func disableCardAction(_ sender: Any) {
        CardUpdateStatus(status: self.disableCardSwitch.isOn, completion: {cardUpdateResponse in
            print("cardUpdateResponse: \(cardUpdateResponse)")
        })
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
        
        let cardBorderMiddle = UIBezierPath(rect: CGRect(x: 58, y: 43.6, width: self.view.frame.width, height: 0.4))
        let cardLayerMiddle = CAShapeLayer()
        cardLayerMiddle.path = cardBorderMiddle.cgPath
        cardLayerMiddle.fillColor = PayProColors.line.cgColor
        self.cardView.layer.addSublayer(cardLayerMiddle)
        
        let cardBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 87.6, width: self.view.frame.width, height: 0.4))
        let cardLayerBottom = CAShapeLayer()
        cardLayerBottom.path = cardBorderBottom.cgPath
        cardLayerBottom.fillColor = PayProColors.line.cgColor
        self.cardView.layer.addSublayer(cardLayerBottom)
        
        
        let upgradeBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let upgradeLayerTop = CAShapeLayer()
        upgradeLayerTop.path = upgradeBorderTop.cgPath
        upgradeLayerTop.fillColor = PayProColors.line.cgColor
        self.upgradeView.layer.addSublayer(upgradeLayerTop)
        
        let upgradeBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 43.6, width: self.view.frame.width, height: 0.4))
        let upgradeLayerBottom = CAShapeLayer()
        upgradeLayerBottom.path = upgradeBorderBottom.cgPath
        upgradeLayerBottom.fillColor = PayProColors.line.cgColor
        self.upgradeView.layer.addSublayer(upgradeLayerBottom)
        
        
        let infoBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let infoLayerTop = CAShapeLayer()
        infoLayerTop.path = infoBorderTop.cgPath
        infoLayerTop.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerTop)
        
        let infoBorderMiddle = UIBezierPath(rect: CGRect(x: 0, y: 43.6, width: self.view.frame.width, height: 0.4))
        let infoLayerMiddle = CAShapeLayer()
        infoLayerMiddle.path = infoBorderMiddle.cgPath
        infoLayerMiddle.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerMiddle)
        
        let infoBorderMiddleB = UIBezierPath(rect: CGRect(x: 0, y: 87.6, width: self.view.frame.width, height: 0.4))
        let infoLayerMiddleB = CAShapeLayer()
        infoLayerMiddleB.path = infoBorderMiddleB.cgPath
        infoLayerMiddleB.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerMiddleB)
        
        let infoBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 131.6, width: self.view.frame.width, height: 0.4))
        let infoLayerBottom = CAShapeLayer()
        infoLayerBottom.path = infoBorderBottom.cgPath
        infoLayerBottom.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerBottom)
        
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
        print("user status: \(User.currentUser()?.status.rawValue)")
        if User.currentUser()?.status == User.Status.statusActivated {
            self.nameLabel.text = (User.currentUser()?.forename)!+" "+(User.currentUser()?.lastname)!
        } else {
            self.nameLabel.text = "Your name"
            self.nameArrow.isHidden = true
        }
        
        if User.currentUser()?.cardStatus == User.CardStatus.notOrdered ||
            User.currentUser()?.cardStatus == User.CardStatus.ordered {
            self.disableCardSwitch.isEnabled = false
            
        } else if User.currentUser()?.cardStatus == User.CardStatus.activated ||
            User.currentUser()?.cardStatus == User.CardStatus.disabled {
            self.disableCardSwitch.isEnabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "profileViewSegue" {
            if User.currentUser()?.status == User.Status.statusActivated {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOldPasscodeSegue" {
            let changePasscodeVC : PPPasscodeViewController = segue.destination as! PPPasscodeViewController
            changePasscodeVC.changePassword = true
        }
    }
}
