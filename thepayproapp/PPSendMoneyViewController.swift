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
//    var userStatus: User.Status = .statusDemo
    var userStatus: User.Status = (User.currentUser()?.status)!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        userStatus = (User.currentUser()?.status)!
        if sendMoney.getLoadProcess() == 0 {
            sendMoney.deleteSavedData()
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
//        self.sendMoney.setLoadProcess(loadProcessValue: 1)
//        self.sendMoney.setOperationType(operationTypeValue: 0)
//        
//        self.dismiss(animated: true, completion: {
//            self.performSegue(withIdentifier: "sendMoneySegue", sender: self)
//        })

    }
    
    func ContactBankTransfer(contact: Contact)
    {
//        self.sendMoney.setLoadProcess(loadProcessValue: 1)
//        self.sendMoney.setOperationType(operationTypeValue: 0)
//        
//        self.dismiss(animated: true, completion: {
//            self.performSegue(withIdentifier: "sendMoneySegue", sender: self)
//        })
    }
    
    func ContactInvite(contact: Contact)
    {
//        self.sendMoney.setLoadProcess(loadProcessValue: 1)
//        self.sendMoney.setOperationType(operationTypeValue: 2)
//        self.sendMoney.setBeneficiaryName(beneficiaryNameValue: contact.displayName())
//        self.sendMoney.setphoneNumber(phoneNumberValue: contact.getPhoneNumber())
//        
//        self.dismiss(animated: true, completion: {
//            self.performSegue(withIdentifier: "sendMoneySegue", sender: self)
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
    
    func ContactIntroduceBitcoinAddress(){
    
        self.sendMoney.setLoadProcess(loadProcessValue: 1)
        self.sendMoney.setOperationType(operationTypeValue: 0)
        self.sendMoney.setCurrencyType(currencyTypeValue: 1)
        self.sendMoney.setFixedCurrency(fixedCurrencyValue: true)
    
        self.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "introduceBitcoinAddressSegue", sender: self)
        })
    }
    
    func ContactSendInApp(contact: Contact)
    {
        self.sendMoney.setLoadProcess(loadProcessValue: 1)
        self.sendMoney.setOperationType(operationTypeValue: 1)
        self.sendMoney.setBeneficiaryName(beneficiaryNameValue: contact.getBeneficiaryName())
        self.sendMoney.setcontactId(contactIdValue: contact.getContactId())
        
        if userStatus != .statusActivated{
            self.sendMoney.setCurrencyType(currencyTypeValue: 1)
            self.sendMoney.setFixedCurrency(fixedCurrencyValue: true)
        }else{
            self.sendMoney.setFixedCurrency(fixedCurrencyValue: false)
        }
        
        self.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "sendMoneySegue", sender: self)
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
        
//            let bankTransfeButtonAction = UIAlertAction(title: "Bank transfer", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                //enabled block load process
//                self.sendMoney.setLoadProcess(loadProcessValue: 1)
//                self.sendMoney.setOperationType(operationTypeValue: 0)
//                
//                self.dismiss(animated: true, completion: {
//                    self.performSegue(withIdentifier: "sendMoneySegue", sender: self)
//                })
//            })
//        
//            alert.addAction(bankTransfeButtonAction)
            
            let introduceBitcoinAddressAction = UIAlertAction(title: "Introduce Bitcoin Address", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                self.ContactIntroduceBitcoinAddress()
            })
            
            alert.addAction(introduceBitcoinAddressAction)
        
            let inviteButtonAction = UIAlertAction(title: "Invite someone to PayPro", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                
                self.sendMoney.setLoadProcess(loadProcessValue: 1)
                self.sendMoney.setOperationType(operationTypeValue: 2)
                self.sendMoney.setBeneficiaryName(beneficiaryNameValue: contact.displayName())
                self.sendMoney.setphoneNumber(phoneNumberValue: contact.getPhoneNumber())
                
                if self.userStatus != .statusActivated{
                    self.sendMoney.setCurrencyType(currencyTypeValue: 1)
                    self.sendMoney.setFixedCurrency(fixedCurrencyValue: true)
                }else{
                    self.sendMoney.setFixedCurrency(fixedCurrencyValue: false)
                }
                
                self.dismiss(animated: true, completion: {
                    self.performSegue(withIdentifier: "sendMoneySegue", sender: self)
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
            
            if userStatus != .statusActivated{
                self.sendMoney.setCurrencyType(currencyTypeValue: 1)
                self.sendMoney.setFixedCurrency(fixedCurrencyValue: true)
            }else{
                self.sendMoney.setFixedCurrency(fixedCurrencyValue: false)
            }
            
            self.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "sendMoneySegue", sender: self)
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
        if segue.identifier == "sendMoneySegue" {
            let sendMoneyInAppVC : PPSendMoneyAmountViewController = segue.destination as! PPSendMoneyAmountViewController
            sendMoneyInAppVC.sendMoney = sendMoney
        }else if segue.identifier == "introduceBitcoinAddressSegue" {
            let introduceBitcoinAddressVC : PPBitcoinAddr = segue.destination as! PPBitcoinAddr
            introduceBitcoinAddressVC.sendMoney = sendMoney
        }
        
    }

}
