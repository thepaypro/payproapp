//
//  sendMoney.swift
//  thepayproapp
//
//  Created by Roger Baiget on 22/9/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

open class SendMoney {
    fileprivate var load_process: Int = 0 //0:initial load not active, 1:initial load active
    fileprivate var finish_process: Int = 0 //0:process are active, 1:process are finished
    fileprivate var operation_type: Int = 0 //0:bankTransfe, 1:sendMoneyIntraApp, 2:sendMoneyInvite
    fileprivate var currency_type: Int = 0 //0:GBP 1:BTC
    fileprivate var amount: String?
    fileprivate var forename: String?
    fileprivate var lastname: String?
    fileprivate var account_details_type: Int?
    fileprivate var account_number: String?
    fileprivate var shortcode: String?
    fileprivate var iban: String?
    fileprivate var bic: String?
    fileprivate var message: String?
    fileprivate var reason: String?
    fileprivate var reasonExplain: String?
    fileprivate var beneficiaryName: String?
    fileprivate var phoneNumber: String?
    fileprivate var contactId: Int?
    fileprivate var label: String?
    
    open func bitcoinURISaveData (bitcoinURIString: String?) -> Bool{
        
        //bitcoin:175tWpb8K1S7NmH4Zx6rewF9WQrcZv245W?amount=50&label=Luke-Jr&message=Donation%20for%20project%20xyz
        var isBitcoinUriValid: Bool = true
        var bitcoinUri: [String?]

        //print(bitcoinURIString?.components(separatedBy: ":"))
        
        if let bitcoinUriScheme: [String?] = bitcoinURIString?.components(separatedBy: ":"), bitcoinUriScheme[0] == "bitcoin" &&  bitcoinUriScheme[1] != nil{
            bitcoinUri = [bitcoinUriScheme[1]]
        }else{
            return false
        }
        
        // need to check if the addr is valid
        bitcoinUriAddr: if let bitcoinUriAddr: [String?] = bitcoinUri[0]?.components(separatedBy: "?"){
            if bitcoinUriAddr.count > 2{
                isBitcoinUriValid = false
                break bitcoinUriAddr
            }
            account_number = bitcoinUriAddr[0]
            if bitcoinUriAddr.count == 2{
               bitcoinUri.append(bitcoinUriAddr[1])
            }else{
                return true
            }
        }else{
            return false
        }
        
        if let bitcoinUriParams: [String?] = bitcoinUri[1]?.components(separatedBy: "&"){
            parametersLoop: for (_,query) in bitcoinUriParams.enumerated(){
                if let param: [String] = query?.components(separatedBy: "="){
                    if param[0] == "amount" || param[0] == "size"{
                        let regex = try! NSRegularExpression(pattern: "^[0-9]*\\.?[0-9]{0,8}$")
                        if (regex.firstMatch(in: param[1], options: [], range: NSMakeRange(0, param[1].utf16.count))) != nil{
                            amount = param[1]
                        }else{
                            return false
                        }
                    }
                    else if param[0] == "label" {
                        label = param[1].removingPercentEncoding
                    }
                    else if param[0] == "message" {
                        message = param[1].removingPercentEncoding
                    }else{
                        isBitcoinUriValid = false
                        break parametersLoop
                    }
                }else{
                    isBitcoinUriValid = false
                    break parametersLoop
                }
            }
        }else{
            return false
        }
        return isBitcoinUriValid 
    }
    
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
    open func getAmountWithCurrencySymbol() -> String {
        if currency_type == 0{
            return "£ " + amount!
        }else if currency_type == 1{
            return amount! + " bits"
        }else{
            return ""
        }
    }
    
    open func setCurrencyType(currencyTypeValue: Int){
        currency_type = currencyTypeValue
    }
    
    open func setAmount(amountToSend: String) {
        amount = amountToSend
    }
    
    open func getAmount() -> String? {
        return amount
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
    
    open func getMessage() -> String? {
        return message
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
    
    open func getLabel() -> String? {
        return label
    }
    
    open func setLabel(labelValue: String){
        label = labelValue
    }
}
