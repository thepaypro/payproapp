//
//  PPBankTransfeReferenceViewController.swift
//  payproapp
//
//  Created by Enric Giribet on 20/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class TPPBankTransfeReferenceViewController: UIViewController, ReferenceViewControllerDelegate
{
    @IBOutlet weak var labelReference: UILabel!
    @IBOutlet weak var viewOtherReason: UIView!
    @IBOutlet weak var textInfoView: UIView!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var reasonView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let noteBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let noteLayerTop = CAShapeLayer()
        noteLayerTop.path = noteBorderTop.cgPath
        noteLayerTop.fillColor = PayProColors.line.cgColor
        self.noteView.layer.addSublayer(noteLayerTop)
        
        let noteBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 41.5, width: self.view.frame.width, height: 0.4))
        let noteLayerBottom = CAShapeLayer()
        noteLayerBottom.path = noteBorderBottom.cgPath
        noteLayerBottom.fillColor = PayProColors.line.cgColor
        self.noteView.layer.addSublayer(noteLayerBottom)
        
        let reasonBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let reasonLayerTop = CAShapeLayer()
        reasonLayerTop.path = reasonBorderTop.cgPath
        reasonLayerTop.fillColor = PayProColors.line.cgColor
        self.reasonView.layer.addSublayer(reasonLayerTop)
        
        let reasonBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 41.5, width: self.view.frame.width, height: 0.4))
        let reasonLayerBottom = CAShapeLayer()
        reasonLayerBottom.path = reasonBorderBottom.cgPath
        reasonLayerBottom.fillColor = PayProColors.line.cgColor
        self.reasonView.layer.addSublayer(reasonLayerBottom)
        
        let otherReasonBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 41.5, width: self.view.frame.width, height: 0.4))
        let otherReasonLayerBottom = CAShapeLayer()
        otherReasonLayerBottom.path = otherReasonBorderBottom.cgPath
        otherReasonLayerBottom.fillColor = PayProColors.line.cgColor
        self.viewOtherReason.layer.addSublayer(otherReasonLayerBottom)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if self.labelReference.text == "Other" && self.viewOtherReason.isHidden == true {
            print("aa")
            self.textInfoView.frame.origin.y += 43
        }
        
        if self.labelReference.text != "Other" && self.viewOtherReason.isHidden == false {
            print("bb")
            self.textInfoView.frame.origin.y -= 43
        }
        
        if self.labelReference.text == "Other" {
            self.viewOtherReason.isHidden = false
        } else {
            self.viewOtherReason.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueReferenceList"{
            let vc = segue.destination as! PPBankTransfeReferenceListViewController
            vc.itemSelected = labelReference.text!
            vc.delegate = self
        }
    }
    
    func referenceSelected(controller: PPBankTransfeReferenceListViewController, text: String?) {
        self.labelReference.text = text
    }
}

