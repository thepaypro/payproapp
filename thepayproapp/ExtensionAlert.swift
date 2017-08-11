//
//  ExtensionAlert.swift
//  thepayproapp
//
//  Created by Enric Giribet Usó on 8/8/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

extension UIAlertController {
    func displayAlert(code: String) -> UIAlertController {
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
            
        case "error_profile_saving_forename":
            let alert = UIAlertController(
                title: "Name error!",
                message: "Please, enter a valid name.",
                preferredStyle: UIAlertControllerStyle.alert)
            
            let confirmAction = UIAlertAction(
                title: "Ok",
                style: .default)
            
            alert.addAction(confirmAction)
            
            return alert
            
        case "error_profile_saving_lastname":
            let alert = UIAlertController(
                title: "Surname error!",
                message: "Please, enter a valid name.",
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
