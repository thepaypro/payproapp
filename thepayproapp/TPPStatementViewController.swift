//
//  TPPStatementViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 14/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class TPPStatementViewController: UIViewController {

    @IBOutlet weak var viewPickerStarts: UIView!
    @IBOutlet weak var datePickerStarts: UIDatePicker!
    @IBOutlet weak var viewEnds: UIView!
    
    @IBAction func buttonStarts(_ sender: Any) {
        animate(duration: 0.5, c: {
            self.view.layoutIfNeeded()
        }, type: "start")
    }
    
    
    @IBOutlet weak var viewPickerEnds: UIView!
    
    @IBAction func buttonEnds(_ sender: Any) {
        animate(duration: 0.5, c: {
            self.view.layoutIfNeeded()
        }, type: "end")
    }
    
    @IBOutlet weak var datePickerEnds: UIDatePicker! {
        didSet {
            datePickerEnds.isHidden = true
            datePickerEnds.frame.size.height = 0
            datePickerEnds.alpha = 0
        }
    }
    @IBOutlet weak var labelDateStart: UILabel!
    @IBOutlet weak var labelDateEnd: UILabel!
    @IBOutlet weak var viewEmailSend: UIView!
    @IBOutlet weak var lineViewBottomEnds: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerStarts.addTarget(self, action: #selector(dateStartChanged(_:)), for: .valueChanged)
        datePickerEnds.addTarget(self, action: #selector(dateEndChanged(_:)), for: .valueChanged)
        self.viewPickerStarts.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        labelDateStart.text = dateFormatter.string(from: Date())
        labelDateEnd.text = dateFormatter.string(from: Date())
    }
    
    func dateStartChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        self.labelDateStart.text = dateFormatter.string(from: sender.date)
    }
    
    func dateEndChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        self.labelDateEnd.text = dateFormatter.string(from: sender.date)
    }

    func animate(duration:Double, c: @escaping () -> Void, type:String) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration, animations: {
                
                if type == "start" {
                    if self.viewPickerStarts.isHidden == false {
                        self.viewPickerStarts.alpha = 0
                        self.viewPickerStarts.frame.size.height = 0
                        self.datePickerStarts.frame.size.height = 0
                        self.datePickerStarts.alpha = 0
                        
                        self.viewEnds.frame.origin.y -= 150
                        self.viewPickerEnds.frame.origin.y -= 150
                        
                        self.viewPickerStarts.isHidden = true
                    } else {
                        self.viewPickerStarts.isHidden = false
                        self.viewPickerStarts.alpha = 1
                        self.viewPickerStarts.frame.size.height += 150
                        
                        self.datePickerStarts.isHidden = false
                        self.datePickerStarts.frame.size.height += 150
                        self.datePickerStarts.alpha = 1
                        
                        self.viewEnds.frame.origin.y += 150
                        self.viewPickerEnds.frame.origin.y += 150
                    }
                }
                
                if type == "end" {
                    if self.datePickerEnds.isHidden == false {
                        self.datePickerEnds.isHidden = true
                        self.lineViewBottomEnds.frame.origin.y -= 150
                        
                        self.viewEmailSend.frame.origin.y -= 150
                        
                        self.datePickerEnds.frame.size.height -= 150
                        self.datePickerEnds.alpha = 0
                    } else {
                        self.datePickerEnds.isHidden = false
                        self.lineViewBottomEnds.frame.origin.y += 150
                        
                        self.viewEmailSend.frame.origin.y += 150
                        
                        self.datePickerEnds.frame.size.height += 150
                        self.datePickerEnds.alpha = 1
                    }
                }
                
            })
        }, completion: {  (finished: Bool) in
            c()
        })
    }

}
