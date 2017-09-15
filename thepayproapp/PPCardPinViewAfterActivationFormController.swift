//
//  PPCardPinViewAfterActivationFormController.swift
//  thepayproapp
//
//  Created by Roger Baiget on 5/9/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPCardPinViewAfterActivationFormController: UIViewController
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pinView: UIView!
    @IBOutlet weak var pinCrossView: UIView!
    

    @IBOutlet weak var pinMaskView: UIView!
    @IBOutlet weak var crossMaskView: UIView!
    @IBOutlet weak var dragMasksView: UIView!

    //var crossMaskCGRect: CGRect!
    
    var offsetBetweenMasksAndDragMasksView: CGFloat = -50;
    var pin: String = ""
    var visiblePinScreenTime: Int?
    var visiblePinTime: Int? = 1
    var CVV2: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinView.mask = pinMaskView
        
        pinView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(moveMaskToPoint)))
        
        self.displayNavBarActivity()
        let pinArray = self.pin.characters.map{String($0)}
        for (index,ch) in pinArray.enumerated()  {
            let currentLabel = self.pinView.subviews[index].subviews.first as! UILabel
            currentLabel.text = ch
        }
        self.dismissNavBarActivity()
        
        let backButton = UIBarButtonItem(title:"Back",style: .done, target: self, action: #selector(self.goBack(_:)))
        navigationItem.leftBarButtonItems = [backButton]

        Timer.scheduledTimer(timeInterval: Double(visiblePinScreenTime!), target: self, selector: #selector(self.goBack), userInfo: nil, repeats: false);
    }
    
    func inverseMask(viewToMask: UIView, maskRect: CGRect, invert: Bool = false) {
        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        if (invert) {
            path.addRect(viewToMask.bounds)
        }
        path.addRect(maskRect)
        
        maskLayer.path = path
        if (invert) {
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        
        // Set the mask of the view.
        viewToMask.layer.mask = maskLayer;
    }
    
    func moveMaskToPoint(_ sender: UIPanGestureRecognizer) {

        crossMaskView.isHidden = false;
        dragMasksView.center.x = sender.location(in: pinView).x
        if(sender.velocity(in: pinView).x < 0){
            pinMaskView.center.x = dragMasksView.center.x - offsetBetweenMasksAndDragMasksView
            crossMaskView.center.x = dragMasksView.center.x - offsetBetweenMasksAndDragMasksView
        }else{
            pinMaskView.center.x = dragMasksView.center.x + offsetBetweenMasksAndDragMasksView
            crossMaskView.center.x = dragMasksView.center.x + offsetBetweenMasksAndDragMasksView
        }
        
        if sender.state == UIGestureRecognizerState.ended {
        Timer.scheduledTimer(timeInterval: Double(visiblePinTime!), target: self, selector: #selector(self.moveMasksOutofSight), userInfo: nil, repeats: false);
        }

    }
    func moveMasksOutofSight(){
        
        crossMaskView.isHidden = true;
        dragMasksView.center.x = 36
        pinMaskView.center.x = dragMasksView.center.x + offsetBetweenMasksAndDragMasksView
        crossMaskView.center.x = dragMasksView.center.x + offsetBetweenMasksAndDragMasksView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func onConfirmAction(_: UIAlertAction) -> Void{
        goBack()
    }*/
    
    func goBack(_:Any) -> Void{
        print("ImGoingBack")
        crossMaskView.backgroundColor = nil
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}


