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
import MessageUI

class PPSendMoneyViewController: UIViewController, PickerDelegate, MFMessageComposeViewControllerDelegate
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
        sendMoney.setFinishProcess(finishProcessValue: 0)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func ContacPickerNotInList(controller: ContactsPicker)
    {
        self.sendMoney.setLoadProcess(loadProcessValue: 1)
        self.sendMoney.setOperationType(operationTypeValue: 0)
        
        self.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "bankTransfeSegue", sender: self)
        })

    }
    
    func ContactBankTransfer(contact: Contact)
    {
        self.sendMoney.setLoadProcess(loadProcessValue: 1)
        self.sendMoney.setOperationType(operationTypeValue: 0)
        
        self.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "bankTransfeSegue", sender: self)
        })
    }
    
    func ContactInvite(contact: Contact)
    {
//        self.sendMoney.setLoadProcess(loadProcessValue: 1)
//        self.sendMoney.setOperationType(operationTypeValue: 2)
//        self.sendMoney.setBeneficiaryName(beneficiaryNameValue: contact.displayName())
//        self.sendMoney.setphoneNumber(phoneNumberValue: contact.getPhoneNumber())
//        
//        self.dismiss(animated: true, completion: {
//            self.performSegue(withIdentifier: "sendMoneyInAppSegue", sender: self)
//        })
        print(contact.getPhoneNumber())
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Hi! I am trying to send you money via PayPro but I see you don't have an account. Can you download it so you can instantly have the money? It's on the AppStore :)"
            controller.recipients = [contact.getPhoneNumber()]
            controller.messageComposeDelegate = self
            self.dismiss(animated: true, completion: {
                self.present(controller, animated: true, completion: nil)
            })
        } else {
            print("no puedo enviar SMS!!")
        }
    }
    
    func ContactSendInApp(contact: Contact)
    {
        self.sendMoney.setLoadProcess(loadProcessValue: 1)
        self.sendMoney.setOperationType(operationTypeValue: 1)
        self.sendMoney.setBeneficiaryName(beneficiaryNameValue: contact.getBeneficiaryName())
        self.sendMoney.setcontactId(contactIdValue: contact.getContactId())
        
        self.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "sendMoneyInAppSegue", sender: self)
        })
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
                
                self.sendMoney.setLoadProcess(loadProcessValue: 1)
                self.sendMoney.setOperationType(operationTypeValue: 2)
                self.sendMoney.setBeneficiaryName(beneficiaryNameValue: contact.displayName())
                self.sendMoney.setphoneNumber(phoneNumberValue: contact.getPhoneNumber())
                
                self.dismiss(animated: true, completion: {
                    self.performSegue(withIdentifier: "sendMoneyInAppSegue", sender: self)
                })
            })
        
            alert.addAction(inviteButtonAction)
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
            alert.addAction(cancelAction)
        
            self.present(alert, animated: true, completion: nil)
            
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
        self.tabBarController?.selectedIndex = 2
        self.dismiss(animated: true, completion: nil)
    }
    
    func ContactPicker(_: ContactsPicker, didSelectMultipleContacts contacts: [Contact]) {
        print("The following contacts are selected")
        for contact in contacts {
            print("\(contact.displayName())")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.sendMoney.setLoadProcess(loadProcessValue: 0)
        
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            
            self.dismiss(animated: true, completion: {
                let alert = UIAlertController(title: "SMS Cancelled", message: "The message has been successfully canceled.", preferredStyle: UIAlertControllerStyle.alert)
                let confirmAction = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(confirmAction)
                
                self.present(alert, animated: true, completion: {
                    self.tabBarController?.selectedIndex = 2
                    self.dismiss(animated: true, completion: nil)
                })
            })
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            
            self.dismiss(animated: true, completion: {
                let alert = UIAlertController(title: "Failed message", message: "Oops! Something went wrong, please try again. If you see the error persists, please contact us at \"Support\".", preferredStyle: UIAlertControllerStyle.alert)
                let confirmAction = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(confirmAction)
                
                self.present(alert, animated: true, completion: {
                    self.tabBarController?.selectedIndex = 2
                    self.dismiss(animated: true, completion: nil)
                })
            })
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: {
                self.tabBarController?.selectedIndex = 2
            })
            
        default:
            break;
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bankTransfeSegue" {
            print("cccc")
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
    open var finish_process: Int = 0 //0:process are active, 1:process are finished
    open var operation_type: Int = 0 //0:bankTransfe, 1:sendMoneyIntraApp, 2:sendMoneyInvite
    open var currency_type: Int = 0 //0:GBP 1:BTC
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
    open var contactId: Int?
    
    open func setLoadProcess(loadProcessValue: Int) {
        load_process = loadProcessValue
    }
    
    open func getLoadProcess() -> Int {
        return load_process
    }
    
    open func setFinishProcess(finishProcessValue: Int) {
        finish_process = finishProcessValue
    }
    
    open func getFinishProcess() -> Int {
        return finish_process
    }
    
    open func setOperationType(operationTypeValue: Int) {
        operation_type = operationTypeValue
    }
    
    open func getOperationType() -> Int {
        return operation_type
    }
    
    open func getCurrencyType() ->  Int {
        return currency_type
    }
    
    open func setCurrencyType(currencyTypeValue: Int){
        currency_type = currencyTypeValue
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
    
    open func setcontactId(contactIdValue: Int) {
        contactId = contactIdValue
    }
    
    open func getcontactId() -> Int {
        return contactId!
    }
}
