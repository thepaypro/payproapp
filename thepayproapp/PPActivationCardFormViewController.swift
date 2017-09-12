//
//  PPActivationCardFormViewController.swift
//  thepayproapp
//
//  Created by Roger Baiget on 4/9/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPActivationCardFormViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var verCodeView: UIView!
    @IBOutlet weak var cardNumView: UIView!
    @IBOutlet weak var verCodeInput: UITextField!
    @IBOutlet weak var cardNumInput: UITextField!
    let visiblePinScreenTime: Int = 10
    let verCodeMaxLength: Int = 3
    let cardNumMaxLength: Int = 19
    let cardNumMatchCharacter:  String = "1234567890 "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verCodeInput.delegate = self
        cardNumInput.delegate = self
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        verCodeInput.addTarget(self, action: #selector(editingVerCodeChanged), for: .editingChanged)
        cardNumInput.addTarget(self, action: #selector(editingCardNumChanged), for: .editingChanged)
        
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
        self.cardNumView.layer.addSublayer(layerBottom)
    
    }
    
    func checkActivationCode() -> Bool {
        var cardActivated: Bool = false
        CardActivation(
            activationCode: self.verCodeInput.text!,
            cardNum: self.cardNumInput.text!,
            completion: {
                cardActivationResponse in
                if cardActivationResponse["status"] as! Bool == true {
                    print("cardActivationResponse: \(cardActivationResponse)")
                    cardActivated = true
                }else{
                    if let errorMessage = cardActivationResponse["errorMessage"]{
                        let alert = UIAlertController()
                        self.present(alert.displayAlert(code: errorMessage as! String), animated: true, completion: nil)
                    }else{
                        let errorMessage: String = "error_invalid_verification_code"
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
        case cardNumInput:
            shouldChange = fulfildCardNumFormat(text: prospectiveText as String)
        default:
            break;
        }
        return shouldChange
    }
    func fulfildVerCodeFormat(text: String) -> Bool {
        return text.characters.count <= verCodeMaxLength
    }
    
    func fulfildCardNumFormat(text: String) -> Bool {
        let disallowedCharacterSet = CharacterSet(charactersIn: cardNumMatchCharacter).inverted
        return (text.characters.count <= cardNumMaxLength) && (text.rangeOfCharacter(from: disallowedCharacterSet) == nil)
    }
    
    func editingVerCodeChanged() {
        if (cardNumInput.text?.characters.count == cardNumMaxLength && verCodeInput.text?.characters.count == verCodeMaxLength){
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }else if (verCodeInput.text?.characters.count == verCodeMaxLength){
            cardNumInput.becomeFirstResponder()
        }else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func editingCardNumChanged() {
        if(!(cardNumInput.text?.characters.isEmpty)!){
            
            var spacesAdded:Int = 0
            let cardNumArrayNoFilter = cardNumInput.text?.characters.map{String($0)}
            var cardNumArray = cardNumInput.text?.characters.filter {![" ", "\t", "\n"].contains($0)}
            print("cardNumArray \(cardNumArray)")
            
            var cursorPosition: Int = cardNumInput.offset(from: cardNumInput.beginningOfDocument, to: (cardNumInput.selectedTextRange?.start)!)
        
            let spacePosArray:Array = ["4","8","12"]
            for (index,_) in (cardNumArray!.enumerated())  {
                if (spacePosArray.contains(String(index))){
                    cardNumArray!.insert(" ", at: index + spacesAdded)
                    print("cardNumArrayInFor \(cardNumArray)")
                    print("cardNumArrayNoFilter \(cardNumArrayNoFilter)")
                    if(cursorPosition < (cardNumArray?.count)! ? cardNumArray?[cursorPosition-1] == " " && cardNumArrayNoFilter?[cursorPosition-1] != " " && index == cursorPosition-1-spacesAdded : false){
                        cursorPosition += 1
                    }else if(cursorPosition < (cardNumArray?.count)! ? (cardNumArray?[cursorPosition-1] == " " && index == cursorPosition-1-spacesAdded) : false){
                        cursorPosition -= 1
                    }
                    spacesAdded += 1
                }
            }
  
            cardNumInput.text = cardNumArray.map{String($0)}
        
            let newCursorPosition: UITextPosition? = cardNumInput.position(from: cardNumInput.beginningOfDocument, offset: cursorPosition > (cardNumArray?.count)! ? (cardNumArray?.count)! : cursorPosition)
        
            cardNumInput.selectedTextRange = cardNumInput.textRange(from: newCursorPosition!, to: newCursorPosition!)
            
            
            
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            if (cardNumInput.text?.characters.count == cardNumMaxLength && verCodeInput.text?.characters.count == verCodeMaxLength){
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
        if identifier == "showPINCodeFromActivateCardFormSegue" {
            return checkActivationCode()
        } else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPINCodeFromActivateCardFormSegue" {
            let PINCodeVC : PPCardPinViewAfterActivationFormController = segue.destination as! PPCardPinViewAfterActivationFormController
            PINCodeVC.visiblePinScreenTime = self.visiblePinScreenTime

        }
    }
}

