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
            documentTypePicker.frame.size.height = 0
            documentTypePicker.alpha = 0
        }
    }
    @IBOutlet weak var documentValueView: UIView!
    @IBOutlet weak var documentTypeLabel: UILabel!
    @IBAction func documentTypeButton(_ sender: Any) {
        self.documentTypeInput.resignFirstResponder()
        animate(duration: 0.5, c: {
            self.view.layoutIfNeeded()
        }, type: "toogle")
    }
    @IBAction func documentValueAction(_ sender: Any) {
        closePicker()
    }
    @IBOutlet weak var documentTypeInput: UITextField!
    
    
    var documentTypes = ["Driving Licence", "Passport", "National ID Card"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let documentTypeBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let documentTypeLayerTop = CAShapeLayer()
        documentTypeLayerTop.path = documentTypeBorderTop.cgPath
        documentTypeLayerTop.fillColor = PayProColors.line.cgColor
        self.documentTypeView.layer.addSublayer(documentTypeLayerTop)
        
        let documentValueBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let documentValueLayerTop = CAShapeLayer()
        documentValueLayerTop.path = documentValueBorderTop.cgPath
        documentValueLayerTop.fillColor = PayProColors.line.cgColor
        self.documentValueView.layer.addSublayer(documentValueLayerTop)
        
        let documentValueBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 43.6, width: self.view.frame.width, height: 0.4))
        let documentValueLayerBottom = CAShapeLayer()
        documentValueLayerBottom.path = documentValueBorderBottom.cgPath
        documentValueLayerBottom.fillColor = PayProColors.line.cgColor
        self.documentValueView.layer.addSublayer(documentValueLayerBottom)
        
        self.documentTypeInput.addTarget(self, action:#selector(closePicker), for: UIControlEvents.allEvents)
        
        documentTypePicker.delegate = self
        documentTypePicker.dataSource = self
        
    }
    
    func closePicker()
    {
        animate(duration: 0.5, c: {
            self.view.layoutIfNeeded()
        }, type: "close")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    self.documentTypePickerView.frame.size.height = 0
                    self.documentTypePicker.frame.size.height = 0
                    self.documentTypePickerView.alpha = 0
                    self.documentTypePicker.alpha = 0
                        
                    self.documentValueView.frame.origin.y -= 150
                    
                } else if self.documentTypePicker.alpha == 0 && type == "toogle"{
                    self.documentTypePickerView.frame.size.height = 150
                    self.documentTypePicker.frame.size.height = 150
                    self.documentTypePickerView.alpha = 1
                    self.documentTypePicker.alpha = 1
                    
                    self.documentValueView.frame.origin.y += 150
                }
                
            })
        }, completion: {  (finished: Bool) in
            c()
        })
    }
}

