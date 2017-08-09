//
//  PPProfileEditDocumentViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 13/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPProfileEditDocumentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var documentTypeView: UIView!
    @IBOutlet weak var documentTypeButton: UIButton!
    @IBOutlet weak var documentTypePickerView: UIView!{
        didSet {
            documentTypePickerView.frame.size.height = 0
            documentTypePickerView.alpha = 0
        }
    }
    @IBOutlet weak var documentTypePicker: UIPickerView!{
        didSet{
            documentTypePicker.alpha = 0
        }
    }

    @IBOutlet weak var documentTypeLabel: UILabel!
    @IBAction func documentTypeButton(_ sender: Any) {
        animate(duration: 0.5, c: {
            self.view.layoutIfNeeded()
        }, type: "toogle")
    }
    @IBOutlet weak var lineView: UIView!
    
    
    var documentTypes = ["Driving Licence", "Passport", "National ID Card"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let documentTypeBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let documentTypeLayerTop = CAShapeLayer()
        documentTypeLayerTop.path = documentTypeBorderTop.cgPath
        documentTypeLayerTop.fillColor = PayProColors.line.cgColor
        self.documentTypeView.layer.addSublayer(documentTypeLayerTop)
        
        let documentTypePickerBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 149.6, width: self.view.frame.width, height: 0.4))
        let documentTypePickerLayerBottom = CAShapeLayer()
        documentTypePickerLayerBottom.path = documentTypePickerBorderBottom.cgPath
        documentTypePickerLayerBottom.fillColor = PayProColors.line.cgColor
        self.documentTypePickerView.layer.addSublayer(documentTypePickerLayerBottom)
        
        let lineViewBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let lineViewLayerTop = CAShapeLayer()
        lineViewLayerTop.path = lineViewBorderTop.cgPath
        lineViewLayerTop.fillColor = PayProColors.line.cgColor
        self.lineView.layer.addSublayer(lineViewLayerTop)
        
        documentTypePicker.delegate = self
        documentTypePicker.dataSource = self
        
        self.setupView()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupView()
    }
    
    func setupView()
    {
        if User.currentUser()?.documentType == "DNI" {
            self.documentTypeLabel.text = "National ID Card"
        } else if User.currentUser()?.documentType == "DRIVING_LICENSE" {
            self.documentTypeLabel.text = "Driving Licence"
        } else if User.currentUser()?.documentType == "PASSPORT" {
            self.documentTypeLabel.text = "Passport"
        }
        
        self.setNavigationBarButton()
    }
    
    func setNavigationBarButton()
    {
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTapped))
        
        self.navigationItem.rightBarButtonItem = nextButton
        
        self.checkNavigation()
    }
    
    func checkNavigation() {
        if self.documentTypeLabel.text == "National ID Card" ||
           self.documentTypeLabel.text == "Driving Licence" ||
            self.documentTypeLabel.text == "Passport" {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func nextTapped()
    {
        performSegue(withIdentifier: "showDocumentPhotoFromProfileEditSegue", sender: self)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return documentTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return documentTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        documentTypeLabel.text = documentTypes[row]
    }
    
    func animate(duration:Double, c: @escaping () -> Void, type:String) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration, animations: {
                if self.documentTypePicker.alpha == 1 {
                    self.documentTypePickerView.frame.size.height -= 150
                    self.documentTypePickerView.alpha -= 1
                    self.documentTypePicker.alpha -= 1
                    
                    self.lineView.isHidden = false
                    
                } else if self.documentTypePicker.alpha == 0 && type == "toogle"{
                    self.documentTypePickerView.frame.size.height += 150
                    self.documentTypePickerView.alpha += 1
                    self.documentTypePicker.alpha += 1
                    
                    self.lineView.isHidden = true
                }
                
            })
        }, completion: {  (finished: Bool) in
            c()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDocumentPhotoFromProfileEditSegue" {
            let updateDocumentVC = segue.destination as! PPDocumentPhotoViewController
            
            if self.documentTypeLabel.text == "Driving Licence" {
                User.currentUser()?.documentType = "DRIVING_LICENSE"
            } else if self.documentTypeLabel.text == "National ID Card" {
                User.currentUser()?.documentType = "DNI"
            } else if self.documentTypeLabel.text == "Passport" {
                User.currentUser()?.documentType = "PASSPORT"
            }

            updateDocumentVC.updateAccount = true
        }
    }
}

