//
//  PPChooseAccountViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 13/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPChooseAccountViewController: UIViewController, UIScrollViewDelegate
{
    var proAccountSelected = true
    
    @IBOutlet weak var proView: UIView!
    @IBOutlet weak var proHeaderIV: UIImageView!
    @IBOutlet weak var proTitleLabel: UILabel!
    @IBOutlet weak var proSubtitleLabel: UILabel!
    @IBOutlet weak var proCheck: UIImageView!
    @IBOutlet weak var proDescriptionTV: UITextView!
    @IBOutlet weak var proViewHeight: NSLayoutConstraint!    
    
    @IBOutlet weak var basicView: UIView!
    @IBOutlet weak var basicHeaderIV: UIImageView!
    @IBOutlet weak var basicTitleLabel: UILabel!
    @IBOutlet weak var basicSubtitleLabel: UILabel!
    @IBOutlet weak var basicCheck: UIImageView!
    @IBOutlet weak var basicDescriptionTV: UITextView!
    @IBOutlet weak var basicViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let chooseButton = UIBarButtonItem(title: "Choose", style: .done, target: self, action: #selector(chooseTapped))
        self.navigationItem.rightBarButtonItem = chooseButton
        
        self.setupView()
    }
    
    func setupView()
    {
        let selectProGR = UITapGestureRecognizer(target: self, action: #selector(selectPro))
        proView.addGestureRecognizer(selectProGR)
        
        let selectBasicGR = UITapGestureRecognizer(target: self, action: #selector(selectBasic))
        basicView.addGestureRecognizer(selectBasicGR)
        
        let proAS = NSMutableAttributedString(string: "Bank Account FREE\nVisa Debit FREE\nFX Transactions (0,6%)\nPOS FREE\nUp to € 2,000 per month FREE\n")
        proAS.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightLight), range: NSRange(location: 0, length: proAS.length))
        proAS.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightMedium), range: NSRange(location: 13, length: 4))
        proAS.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightMedium), range: NSRange(location: 29, length: 4))
        proAS.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightMedium), range: NSRange(location: 61, length: 4))
        proAS.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightMedium), range: NSRange(location: 90, length: 4))
        proAS.addAttribute(NSForegroundColorAttributeName, value: PayProColors.darkBlue, range: NSRange(location: 0, length: proAS.length))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 10.0
        proAS.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: proAS.length))
        proDescriptionTV.attributedText = proAS
        
        let basicAS = NSMutableAttributedString(string: "Bank Account FREE\nVisa Debit (-6 € on your first top up)\nFX Transactions (1%)\nPOS FREE\nUp to € 2,000 per month FREE")
        basicAS.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightLight), range: NSRange(location: 0, length: basicAS.length))
        basicAS.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightMedium), range: NSRange(location: 13, length: 4))
        basicAS.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightMedium), range: NSRange(location: 82, length: 4))
        basicAS.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightMedium), range: NSRange(location: 111, length: 4))
        basicAS.addAttribute(NSForegroundColorAttributeName, value: PayProColors.darkBlue, range: NSRange(location: 0, length: basicAS.length))
        basicAS.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: basicAS.length))
        basicDescriptionTV.attributedText = basicAS
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectPro()
    {
        proAccountSelected = true
        
        proViewHeight.constant = 267.0
        proCheck.isHidden = false
        proTitleLabel.textColor = UIColor.white
        proSubtitleLabel.textColor = UIColor.white
        proHeaderIV.image = UIImage(named: "proSelected")
        
        basicViewHeight.constant = 80.0
        basicCheck.isHidden = true
        basicTitleLabel.textColor = PayProColors.darkBlue
        basicSubtitleLabel.textColor = PayProColors.darkBlue
        basicHeaderIV.image = UIImage(named: "basic")
    }
    
    func selectBasic()
    {
        proAccountSelected = false
        
        basicViewHeight.constant = 267.0
        basicCheck.isHidden = false
        basicTitleLabel.textColor = UIColor.white
        basicSubtitleLabel.textColor = UIColor.white
        basicHeaderIV.image = UIImage(named: "basicSelected")
        
        proViewHeight.constant = 80.0
        proCheck.isHidden = true
        proTitleLabel.textColor = PayProColors.darkBlue
        proSubtitleLabel.textColor = PayProColors.darkBlue
        proHeaderIV.image = UIImage(named: "pro")
    }
    
    func chooseTapped()
    {        
        performSegue(withIdentifier: "showFirstFormVCSegue", sender: self)
//        performSegue(withIdentifier: "testSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showFirstFormVCSegue"
        {
//            let cardFormVC = segue.destination as! PPCardFirstFormViewController
//            cardFormVC.proAccountSelected = self.proAccountSelected
            
            let user = User.currentUser()
            
            if self.proAccountSelected == true {
                user?.accountType = .proAccount
            } else if self.proAccountSelected == false {
                user?.accountType = .basicAccount
            }
        }
    }

}
