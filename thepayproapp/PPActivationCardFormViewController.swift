//
//  PPActivationCardFormViewController.swift
//  thepayproapp
//
//  Created by Roger Baiget on 4/9/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPActivationCardFormViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var verCodeView: UIView!
    @IBOutlet weak var PANView: UIView!
    @IBOutlet weak var verCodeInput: UITextField!
    @IBOutlet weak var PANInput: UITextField!
    
    let verCodeMaxLength: Int = 3
    let PANMaxLength: Int = 19
    let PANMatchCharacter:  String = "1234567890 "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verCodeInput.delegate = self
        PANInput.delegate = self
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        verCodeInput.addTarget(self, action: #selector(editingVerCodeChanged), for: .editingChanged)
        PANInput.addTarget(self, action: #selector(editingPANChanged), for: .editingChanged)
        
        let borderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.40))
        let layerTop = CAShapeLayer()
        layerTop.path = borderTop.cgPath
        layerTop.fillColor = PayProColors.line.cgColor
        self.verCodeView.layer.addSublayer(layerTop)
        
        let borderMiddle = UIBezierPath(rect: CGRect(x: 15, y: 42.6, width: self.view.frame.width, height: 0.40))
        let layerMiddle = CAShapeLayer()
        layerMiddle.path = borderMiddle.cgPath
        layerMiddle.fillColor = PayProColors.line.cgColor
        self.verCodeView.layer.addSublayer(layerMiddle)
        
        let borderBottom = UIBezierPath(rect: CGRect(x: 0, y: 41.6, width: self.view.frame.width, height: 0.40))
        let layerBottom = CAShapeLayer()
        layerBottom.path = borderBottom.cgPath
        layerBottom.fillColor = PayProColors.line.cgColor
        self.PANView.layer.addSublayer(layerBottom)
    
    }
    
    func checkActivationCode() -> Bool {
        var cardActivated: Bool = false
        self.displayNavBarActivity()
        CardActivation(
            cardActivationCode: self.verCodeInput.text!,
            PAN: self.PANInput.text!,
            completion: {
                cardActivationResponse in
                self.dismissNavBarActivity()
                if cardActivationResponse["status"] as! Bool == true {
                    print("cardActivationResponse: \(cardActivationResponse)")
                    cardActivated = true
                }else{
                    if let errorMessage = cardActivationResponse["errorMessage"]{
                        let alert = UIAlertController()
                        self.present(alert.displayAlert(code: errorMessage as! String), animated: true, completion: nil)
                    }else{
                        let errorMessage: String = "error"
                        let alert = UIAlertController()
                        self.present(alert.displayAlert(code: errorMessage), animated: true, completion: nil)
                    }
                    print("checkActivationError")
                    cardActivated = false
                }
            }
        )
       return cardActivated
    }
    
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        
        guard let currentText = textField.text else { return true }
        
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        var shouldChange: Bool = false;
        
        switch textField {
        case verCodeInput:
            shouldChange = fulfildVerCodeFormat(text: prospectiveText as String)
        case PANInput:
            shouldChange = fulfildPANFormat(text: prospectiveText as String)
        default:
            break;
        }
        return shouldChange
    }
    func fulfildVerCodeFormat(text: String) -> Bool {
        return text.characters.count <= verCodeMaxLength
    }
    
    func fulfildPANFormat(text: String) -> Bool {
        let disallowedCharacterSet = CharacterSet(charactersIn: PANMatchCharacter).inverted
        return (text.characters.count <= PANMaxLength) && (text.rangeOfCharacter(from: disallowedCharacterSet) == nil)
    }
    
    func editingVerCodeChanged() {
        if (PANInput.text?.characters.count == PANMaxLength && verCodeInput.text?.characters.count == verCodeMaxLength){
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }else if (verCodeInput.text?.characters.count == verCodeMaxLength){
            PANInput.becomeFirstResponder()
        }else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func editingPANChanged() {
        if(!(PANInput.text?.characters.isEmpty)!){
            
            var spacesAdded:Int = 0
            let PANArrayNoFilter = PANInput.text?.characters.map{String($0)}
            var PANArray = PANInput.text?.characters.filter {![" ", "\t", "\n"].contains($0)}
            print("PANArray \(PANArray)")
            
            var cursorPosition: Int = PANInput.offset(from: PANInput.beginningOfDocument, to: (PANInput.selectedTextRange?.start)!)
        
            let spacePosArray:Array = ["4","8","12"]
            for (index,_) in (PANArray!.enumerated())  {
                if (spacePosArray.contains(String(index))){
                    PANArray!.insert(" ", at: index + spacesAdded)
                    print("PANArrayInFor \(PANArray)")
                    print("PANArrayNoFilter \(PANArrayNoFilter)")
                    if(cursorPosition < (PANArray?.count)! ? PANArray?[cursorPosition-1] == " " && PANArrayNoFilter?[cursorPosition-1] != " " && index == cursorPosition-1-spacesAdded : false){
                        cursorPosition += 1
                    }else if(cursorPosition < (PANArray?.count)! ? (PANArray?[cursorPosition-1] == " " && index == cursorPosition-1-spacesAdded) : false){
                        cursorPosition -= 1
                    }
                    spacesAdded += 1
                }
            }
  
            PANInput.text = PANArray.map{String($0)}
        
            let newCursorPosition: UITextPosition? = PANInput.position(from: PANInput.beginningOfDocument, offset: cursorPosition > (PANArray?.count)! ? (PANArray?.count)! : cursorPosition)
        
            PANInput.selectedTextRange = PANInput.textRange(from: newCursorPosition!, to: newCursorPosition!)
            
            
            
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            if (PANInput.text?.characters.count == PANMaxLength && verCodeInput.text?.characters.count == verCodeMaxLength){
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.verCodeInput.becomeFirstResponder()
    }
    
     // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showCVV2FromActivateCardFormSegue" {
            return checkActivationCode()
        } else {
            return true
        }
    }
}

