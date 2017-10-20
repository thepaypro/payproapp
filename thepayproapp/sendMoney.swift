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
    fileprivate var operation_type: Int = 0 //0:OutApp, 1:sendMoneyIntraApp, 2:sendMoneyInvite
    fileprivate var currency_type: Int = 0 //0:GBP 1:BTC
    fileprivate var fixed_currency: Bool = false
    fileprivate var amount: String?
    fileprivate var forename: String?
    fileprivate var lastname: String?
    fileprivate var account_details_type: Int?
    fileprivate var account_number: String?
    fileprivate var bitcoinAddr: String?
    fileprivate var shortcode: String?
    fileprivate var iban: String?
    fileprivate var bic: String?
    fileprivate var message: String?
    fileprivate var reason: String?
    fileprivate var reasonExplain: String?
    fileprivate var beneficiaryName: String?
    fileprivate var phoneNumber: String?
    fileprivate var contactId: Int?
    fileprivate var beneficiaryUserId: Int?
    fileprivate var beneficiaryAccountId: Int?
    fileprivate var label: String?
    
    
    open func deleteSavedData(){
        operation_type = 0
        currency_type = 0
        fixed_currency = false
        amount = nil
        forename = nil
        lastname = nil
        account_details_type = nil
        account_number = nil
        bitcoinAddr = nil
        shortcode = nil
        iban = nil
        bic = nil
        message = nil
        reason = nil
        reasonExplain = nil
        beneficiaryName = nil
        phoneNumber = nil
        contactId = nil
        beneficiaryUserId = nil
        beneficiaryAccountId = nil
        label = nil
    }
    
    open func bitcoinURISaveData (bitcoinURIString: String?, completion: @escaping (_ response: NSDictionary) -> Void)
    {
        
        //bitcoin:175tWpb8K1S7NmH4Zx6rewF9WQrcZv245W?amount=50&label=Luke-Jr&message=Donation%20for%20project%20xyz
        var bitcoinUri: [String?] = []

        //print(bitcoinURIString?.components(separatedBy: ":"))
        
        if let bitcoinUriScheme: [String?] = bitcoinURIString?.components(separatedBy: ":"), bitcoinUriScheme[0] == "bitcoin" &&  bitcoinUriScheme[1] != nil{
            bitcoinUri = [bitcoinUriScheme[1]]
        }else{
            completion(["status": false] as NSDictionary)
            return
        }
        
        // need to check if the addr is valid
        if let bitcoinUriAddr: [String?] = bitcoinUri[0]?.components(separatedBy: "?"){
            if bitcoinUriAddr.count > 2 || !(bitcoinUriAddr[0]?.matchesRegex(regex: "^[13][a-km-zA-HJ-NP-Z0-9]{26,33}$"))!{
                completion(["status": false] as NSDictionary)
                return
            }
            bitcoinAddr = bitcoinUriAddr[0]
            if bitcoinUriAddr.count == 2{
                bitcoinUri.append(bitcoinUriAddr[1])
                if let bitcoinUriParams: [String?] = bitcoinUri[1]?.components(separatedBy: "&"){
                    for (_,query) in bitcoinUriParams.enumerated(){
                        if let param: [String] = query?.components(separatedBy: "="), param.count == 2{
                            if param[0] == "amount" || param[0] == "size"{
                                if param[1].matchesRegex(regex: "^[0-9]*\\.?[0-9]{0,8}$"){
                                    amount = param[1]
                                }else{
                                    completion(["status": false] as NSDictionary)
                                    return
                                }
                            }
                            else if param[0] == "label" {
                                label = param[1].removingPercentEncoding
                            }
                            else if param[0] == "message" {
                                message = param[1].removingPercentEncoding
                            }else{
                                completion(["status": false] as NSDictionary)
                                return
                            }
                        }else{
                            completion(["status": false] as NSDictionary)
                            return
                        }
                    }
                }else{completion(["status": false] as NSDictionary); return}
            }else{completion(["status": true] as NSDictionary); return}
        }else{completion(["status": false] as NSDictionary); return}
        completion(["status": true] as NSDictionary)
        return
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
            return "bits " + amount!
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
    
    open func setBitcoinAddr(bitcoinAddrValue: String) {
        bitcoinAddr = bitcoinAddrValue
    }
    
    open func getBitcoinAddr() -> String? {
        return bitcoinAddr
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
    
    open func setBeneficiaryUserId(beneficiaryUserIdValue: Int) {
        beneficiaryUserId = beneficiaryUserIdValue
    }
    
    open func getBeneficiaryUserId() -> Int? {
        return beneficiaryUserId
    }
    
    open func setBeneficiaryAccountId(beneficiaryAccountIdValue: Int) {
        beneficiaryAccountId = beneficiaryAccountIdValue
    }
    
    open func getBeneficiaryAccountId() -> Int {
        return beneficiaryAccountId!
    }
    
    open func getLabel() -> String? {
        return label
    }
    
    open func setLabel(labelValue: String){
        label = labelValue
    }
    
    open func getFixedCurrency () -> Bool {
        return fixed_currency
    }
    
    open func setFixedCurrency(fixedCurrencyValue: Bool){
        fixed_currency = fixedCurrencyValue
    }
}
