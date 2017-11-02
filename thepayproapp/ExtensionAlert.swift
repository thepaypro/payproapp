//
//  ExtensionAlert.swift
//  thepayproapp
//
//  Created by Enric Giribet Usó on 8/8/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

extension UIAlertController {
    func displayAlert(code: String, actionConfirm: Any = "") -> UIAlertController {
        print("action: \(actionConfirm)")
        switch code {
        case "error":
            let alert = UIAlertController(
                title: "Ups! Sorry, something went wrong :(",
                message: "If this happens again, please contact us on \"Support\".",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction = UIAlertAction(
                title: "Ok",
                style: .default)

            
            alert.addAction(confirmAction)
            
            return alert
        
        case "error_saving":
            let alert = UIAlertController(
                title: "Saving error!",
                message: "Failed to save info.",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction = UIAlertAction(
                title: "Ok",
                style: .default)
            
            alert.addAction(confirmAction)
            
            return alert
            
        case "error_profile_saving_nickname":
            let alert = UIAlertController(
                title: "Nickname error!",
                message: "Please, enter a valid nickname.",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction = UIAlertAction(
                title: "Ok",
                style: .default)
            
            alert.addAction(confirmAction)
            
            return alert
            
        case "error_profile_saving_invalid_format":
            let alert = UIAlertController(
                title: "Invalid Format",
                message: "Please, enter a valid format.",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction = UIAlertAction(
                title: "Ok",
                style: .default)
            
            alert.addAction(confirmAction)
            
            return alert
            
        case "error_invalid_phonenumber":
            let alert = UIAlertController(
                title: "Phone number Error",
                message: "Please, type a valid phone number.",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction = UIAlertAction(
                title: "Ok",
                style: .default)
            
            alert.addAction(confirmAction)
            
            return alert
            
        case "error_invalid_verification_code":
            let alert = UIAlertController(
                title: "Invalid SMS Code",
                message: "Sorry, we have not recongnized the SMS Code introduced. Please, try again.",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction = UIAlertAction(
                title: "Ok",
                style: .default)
            
            alert.addAction(confirmAction)
            
            return alert
            
        case "error_passcode_dont_match":
            let alert = UIAlertController(
                title: "Invalid confirm passcode",
                message: "Put the same passcode",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction = UIAlertAction(
                title: "Ok",
                style: .default)
            
            alert.addAction(confirmAction)
            
            return alert
            
        case "internet_connection_not_available":
            let alert = UIAlertController(
                title: "No Internet Connection",
                message: "Make sure your device is connected to the internet.",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction = UIAlertAction(
                title: "Ok",
                style: .default)
            
            alert.addAction(confirmAction)
            
            return alert
        
        case "internet_connection_error":
            let alert = UIAlertController(
                title: "Internet connection may not work properly :(",
                message: "The data may not be updated correctly",
                preferredStyle: UIAlertControllerStyle.alert)
            
            var confirmAction = UIAlertAction(
                title: "Ok",
                style: .default)
            
            let ac:Any = actionConfirm
            
            if type(of: ac) is AnyClass{
                confirmAction = UIAlertAction(
                    title: "Ok",
                    style: .default,
                    handler: { action in
                        ac
                    }
                )
            }
            
            alert.addAction(confirmAction)
            
            return alert
            
        case "internet_connection_timeout":
            let alert = UIAlertController(
                title: "Internet Connection Timeout",
                message: "Make sure your device is connected to the internet.",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction = UIAlertAction(
                title: "Ok",
                style: .default)
            
            alert.addAction(confirmAction)
            
            return alert
            
        case "transaction_failed":
            let alert = UIAlertController(
                title: "Transaction Failed",
                message: "Error ocurred during create transaction",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction = UIAlertAction(
                title: "Ok",
                style: .default)
            
            alert.addAction(confirmAction)
            
            return alert
            
        case "invalid_bitcoin_addr":
            let alert = UIAlertController(
                title: "Address not valid",
                message: "Bitcoin Address is not valid",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction = UIAlertAction(
                title: "Ok",
                style: .default)
            
            alert.addAction(confirmAction)
            
            return alert
            
        case "invalid_bitcoin_uri":
            let alert = UIAlertController(
                title: "URI not valid",
                message: "Bitcoin Uri is not valid",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction = UIAlertAction(
                title: "Ok",
                style: .default)
            
            alert.addAction(confirmAction)
            
            return alert
            
        case "unable_to_load_transactions":
            let alert = UIAlertController(
                title: "Unable to load Transactions",
                message: "Something went wrong and we could not load the transactions",
                preferredStyle: UIAlertControllerStyle.alert)
                
            let confirmAction = UIAlertAction(
                    title: "Ok",
                    style: .default)
            
            alert.addAction(confirmAction)
            
            return alert
            
        case "error_on_get_pin":
            let alert = UIAlertController(
                title: "Unable to get Pin",
                message: "There is a problem retrieving your PIN. You can get in touch with us on \"Support\".",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction = UIAlertAction(
                title: "Ok",
                style: .default)
            
            alert.addAction(confirmAction)
            
            return alert
            
        case "Insufficient funds":
            let alert = UIAlertController(
                title: "Insufficient funds",
                message: "You don't have sufficient funds",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction = UIAlertAction(
                title: "Ok",
                style: .default)
            
            alert.addAction(confirmAction)
            
            return alert
            
        default:
            let alert = UIAlertController(
                title: "Ups! Sorry, something went wrong :(",
                message: "If this happens again, please contact us on \"Support\".",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction = UIAlertAction(
                title: "Ok",
                style: .default)
            
            alert.addAction(confirmAction)
            
            return alert
        }
    }
}
