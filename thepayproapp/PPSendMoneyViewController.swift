//
//  PPSendMoneyViewController.swift
//  payproapp
//
//  Created by Manuel Ortega Cordovilla on 13/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class PPSendMoneyViewController: UIViewController, PickerDelegate
{
    var sendMoney = SendMoney()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if sendMoney.getLoadProcess() == 0 {
            let contactPickerScene = ContactsPicker(delegate: self, multiSelection:false, subtitleCellType: SubtitleCellValue.phoneNumber)
            let navigationController = UINavigationController(rootViewController: contactPickerScene)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func ContactPicker(_: ContactsPicker, didContactFetchFailed error : NSError)
    {
        print("Failed with error \(error.description)")
    }
    
    func ContactPicker(_: ContactsPicker, didSelectContact contact : Contact)
    {
        print("Contact \(contact.displayName()) has been selected")
        print("getIsPayProUser: \(contact.getIsPayProUser())")
        
        if contact.getIsPayProUser() == false {
            let alert = UIAlertController(title: "Send money by", message: "", preferredStyle: .actionSheet)
        
            let bankTransfeButtonAction = UIAlertAction(title: "Bank transfer", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                //enabled block load process
                self.sendMoney.setLoadProcess(loadProcessValue: 1)
                self.sendMoney.setOperationType(operationTypeValue: 0)
                
                self.dismiss(animated: true, completion: {
                    self.performSegue(withIdentifier: "bankTransfeSegue", sender: self)
                })
            })
        
            alert.addAction(bankTransfeButtonAction)
        
            let inviteButtonAction = UIAlertAction(title: "Invite someone to PayPro", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                print("Second Button pressed")
                
                self.sendMoney.setLoadProcess(loadProcessValue: 1)
                self.sendMoney.setOperationType(operationTypeValue: 2)
                self.sendMoney.setBeneficiaryName(beneficiaryNameValue: contact.displayName())
                self.sendMoney.setphoneNumber(phoneNumberValue: contact.getPhoneNumber())
                
//                self.dismiss(animated: true, completion: {
//                
//                    if (MFMessageComposeViewController.canSendText()) {
//                        let controller = MFMessageComposeViewController()
//                        controller.body = "Enric Giribet te invita a que descarges PayPro App!!! http://www.payproapp.com "
//                        controller.recipients = ["666395251"]
//                        controller.messageComposeDelegate = self
//                        self.present(controller, animated: true, completion: nil)
//                    } else {
//                        print("no puedo enviar SMS!!")
//                    }
//                })
                self.dismiss(animated: true, completion: {
                    self.performSegue(withIdentifier: "sendMoneyInAppSegue", sender: self)
                })
            })
        
            alert.addAction(inviteButtonAction)
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
            alert.addAction(cancelAction)
        
            UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(alert, animated: true, completion: nil)
            
        } else if contact.getIsPayProUser() == true {
            //enabled block load process
            sendMoney.setLoadProcess(loadProcessValue: 1)
            sendMoney.setOperationType(operationTypeValue: 1)
            sendMoney.setBeneficiaryName(beneficiaryNameValue: contact.getBeneficiaryName())
            
            self.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "sendMoneyInAppSegue", sender: self)
            })
        }
        
    }
    
    func ContactPicker(_: ContactsPicker, didCancel error : NSError)
    {
        print("User canceled the selection");
        self.tabBarController?.selectedIndex = 3
        self.dismiss(animated: true, completion: nil)
    }
    
    func ContactPicker(_: ContactsPicker, didSelectMultipleContacts contacts: [Contact]) {
        print("The following contacts are selected")
        for contact in contacts {
            print("\(contact.displayName())")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bankTransfeSegue" {
            let bankTransfeAmountVC : PPBankTransfeAmountViewController = segue.destination as! PPBankTransfeAmountViewController
            bankTransfeAmountVC.sendMoney = sendMoney
            
        } else if segue.identifier == "sendMoneyInAppSegue" {
            let sendMoneyInAppVC : PPSendMoneyAmountViewController = segue.destination as! PPSendMoneyAmountViewController
            sendMoneyInAppVC.sendMoney = sendMoney
        }
    }

}

open class SendMoney {
    open var load_process: Int = 0 //0:initial load not active, 1:initial load active
    open var operation_type: Int = 0 //0:bankTransfe, 1:sendMoneyIntraApp, 2:sendMoneyInvite
    open var amount: String?
    open var forename: String?
    open var lastname: String?
    open var account_details_type: Int?
    open var account_number: String?
    open var shortcode: String?
    open var iban: String?
    open var bic: String?
    open var message: String?
    open var reason: String?
    open var reasonExplain: String?
    open var beneficiaryName: String?
    open var phoneNumber: String?
    
    open func setLoadProcess(loadProcessValue: Int) {
        load_process = loadProcessValue
    }
    
    open func getLoadProcess() -> Int {
        return load_process
    }
    
    open func setOperationType(operationTypeValue: Int) {
        operation_type = operationTypeValue
    }
    
    open func getOperationType() -> Int {
        return operation_type
    }
    
    open func setAmount(amountToSend: String) {
        amount = amountToSend
    }
    
    open func getAmount() -> String {
        return amount!
    }
    
    open func setForename(forenameValue: String) {
        forename = forenameValue
    }
    
    open func getForename() -> String {
        return forename!
    }
    
    open func setLastname(lastnameValue: String) {
        lastname = lastnameValue
    }
    
    open func getLastname() -> String {
        return lastname!
    }
    
    open func setAccountDetailsType(accountDetailsTypeValue: Int) {
        account_details_type = accountDetailsTypeValue
    }
    
    open func getAccountDetailsType() -> Int {
        return account_details_type!
    }
    
    open func setAccountNumber(accountNumberValue: String) {
        account_number = accountNumberValue
    }
    
    open func getAccountNumber() -> String {
        return account_number!
    }
    
    open func setShortcode(shortcodeValue: String) {
        shortcode = shortcodeValue
    }
    
    open func getShortcode() -> String {
        return shortcode!
    }
    
    open func setIban(ibanValue: String) {
        iban = ibanValue
    }
    
    open func getIban() -> String {
        return iban!
    }
    
    open func setBic(bicValue: String) {
        bic = bicValue
    }
    
    open func getBic() -> String {
        return bic!
    }
    
    open func setMessage(messageValue: String) {
        message = messageValue
    }
    
    open func getMessage() -> String {
        return message!
    }
    
    open func setReason(reasonValue: String) {
        reason = reasonValue
    }
    
    open func getReason() -> String {
        return reason!
    }
    
    open func setReasonExplain(reasonExplainValue: String) {
        reasonExplain = reasonExplainValue
    }
    
    open func getReasonExplain() -> String {
        return reasonExplain!
    }
    
    open func setBeneficiaryName(beneficiaryNameValue: String) {
        beneficiaryName = beneficiaryNameValue
    }
    
    open func getBeneficiaryName() -> String {
        return beneficiaryName!
    }
    
    open func setphoneNumber(phoneNumberValue: String) {
        phoneNumber = phoneNumberValue
    }
    
    open func getphoneNumber() -> String {
        return phoneNumber!
    }
}
