//
//  PPCardSecondFormViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 10/07/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

import Eureka

class PPCardSecondFormViewController: FormViewController, PPPrefixSelectionDelegate
{
    var proAccountSelected : Bool = false
    var forename : String?
    var lastname : String?
    var dateOfBirth : String?
    var documentType : String?
    var documentNumber: String?
    var orderingCard: Bool = false
    var updateAccount : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let user = User.currentUser()

        // Do any additional setup after loading the view.
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textField?.font = UIFont.systemFont(ofSize: 17)
            cell.textField?.adjustsFontSizeToFitWidth = true
            cell.textField?.minimumFontSize = 14.0
            cell.textField?.addTarget(self, action: #selector(self.textfieldEdited), for: .editingChanged)
        }
        
        ButtonRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.minimumScaleFactor = 14.0 / (cell.textLabel?.font.pointSize)!
        }

        form +++
            
            Section()
            
            <<< TextRow() {
                $0.tag = "street"
                $0.title = "Street"
                $0.placeholder = "Street"
                $0.baseValue = user?.street
                
                $0.add(rule: RuleRequired())
            }
            
            <<< TextRow() {
                $0.tag = "buildingNumber"
                $0.title = "Building number"
                $0.placeholder = "Building number"
                $0.baseValue = user?.buildingNumber
                
                $0.add(rule: RuleRequired())
            }
            
            <<< ZipCodeRow() {
                $0.tag = "zipcode"
                $0.title = "Postcode"
                $0.placeholder = "Postcode"
                $0.baseValue = user?.postCode
                
                $0.add(rule: RuleRequired())
            }
            
            <<< TextRow() {
                $0.tag = "city"
                $0.title = "City"
                $0.placeholder = "City"
                $0.baseValue = user?.city
                
                $0.add(rule: RuleRequired())
            }
                
            <<< ButtonRow("country") {
                $0.title = user?.countryName ?? "Country"
                $0.presentationMode = .segueName(segueName: "showCountryFormVC", onDismiss: nil)
                $0.value = user?.country ?? nil
                
                $0.add(rule: RuleRequired())
                }
                
                .cellUpdate { cell, row in
                    if user?.countryName == nil {
                        cell.textLabel?.textColor = UIColor.lightGray
                    }
            }
        
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        form.rowBy(tag: "street")?.baseCell.cellBecomeFirstResponder()
        
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView()
    {
        self.setNavigationBarButton()
    }
    
    func setNavigationBarButton()
    {
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTapped))
        
        if orderingCard || updateAccount
        {
            nextButton.title = "Confirm"
        }
        
        self.navigationItem.rightBarButtonItem = nextButton
        
        self.checkNavigation()
    }
    
    func checkNavigation() {
        self.navigationItem.rightBarButtonItem?.isEnabled = form.validate().count == 0
    }
    
    func nextTapped ()
    {
        if form.validate().count == 0
        {
            if orderingCard || updateAccount
            {
                self.displayNavBarActivity()
                
                let identifier: Int64 = Int64((User.currentUser()?.identifier)!)
                
                let streetRow: TextRow? = form.rowBy(tag: "street")
                let street: String = (streetRow?.value)!
                
                let buildingNumberRow: TextRow? = form.rowBy(tag: "buildingNumber")
                let buildingNumber: String = (buildingNumberRow?.value)!
                
                let postCodeRow: ZipCodeRow? = form.rowBy(tag: "zipcode")
                let postCode: String = (postCodeRow?.value)!
                
                let cityRow: TextRow? = form.rowBy(tag: "city")
                let city: String = (cityRow?.value)!
                
                let countryRow: ButtonRow? = form.rowBy(tag: "country")
                let country: String = (countryRow?.value)!
                let countryName: String = (countryRow?.title)!
                
                let accountUpdateDictionary = [
                    "street": street,
                    "buildingNumber": buildingNumber,
                    "postcode": postCode,
                    "city": city,
                    "country": country
                ] as [String : Any]
                
                AccountUpdate(paramsDictionary: accountUpdateDictionary as NSDictionary, completion: { accountUpdateResponse in
                    
                    if accountUpdateResponse["status"] as! Bool == true {
                        let userDictionary = [
                            "id": identifier,
                            "street": street,
                            "buildingNumber": buildingNumber,
                            "postcode": postCode,
                            "city": city,
                            "country": country,
                            "countryName": countryName
                            ] as [String : Any]
                        
                        let updateUser = User.manage(userDictionary: userDictionary as NSDictionary)
                        
                        if updateUser != nil {
                            self.dismissNavBarActivity()
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.dismissNavBarActivity()
                            self.setNavigationBarButton()
                            let alert = UIAlertController()
                            self.present(alert.displayAlert(code: "error_saving"), animated: true, completion: nil)
                        }
                    } else {
                        var errorMessage: String = "error_saving"
                        
                        if accountUpdateResponse["errorMessage"] != nil {
                            errorMessage = accountUpdateResponse["errorMessage"] as! String
                        }
                        
                        self.dismissNavBarActivity()
                        self.setNavigationBarButton()
                        let alert = UIAlertController()
                        self.present(alert.displayAlert(code: errorMessage), animated: true, completion: nil)
                    }
                })
            }
            else
            {
                print("CARD HOLDER ENDPOINT")
                performSegue(withIdentifier: "documentPhotoFromSecondFormSegue", sender: self)
            }
        }
        else
        {
            print("EMPTY MANDATORY FIELDS")
        }
    }
    
    //MARK: - PPPrefixSelectionDelegate
    
    func countryPicker(name: String, alpha2Code: String, callingCodes: String)
    {
        let countryRow: ButtonRow? = form.rowBy(tag: "country")
        countryRow?.title = name
        countryRow?.value = alpha2Code
        countryRow?.reload()
        countryRow?.cell.textLabel?.textColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem?.isEnabled = form.validate().count == 0
    }
    
    // MARK: - TextField's actions
    
    func textfieldEdited()
    {
        self.navigationItem.rightBarButtonItem?.isEnabled = form.validate().count == 0
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showCountryFormVC"
        {
            let countryVC = segue.destination as! PPPrefixSelectionViewController
            countryVC.delegate = self
        }
        
        if segue.identifier == "documentPhotoFromSecondFormSegue"
        {
//            let documentTypePhotoVC = segue.destination as! PPDocumentPhotoViewController
            
            let user = User.currentUser()
            
            let streetRow: TextRow? = form.rowBy(tag: "street")
            user?.street = streetRow?.value
            
            let buildingNumberRow: TextRow? = form.rowBy(tag: "buildingNumber")
            user?.buildingNumber = buildingNumberRow?.value
            
            let postCodeRow: ZipCodeRow? = form.rowBy(tag: "zipcode")
            user?.postCode = postCodeRow?.value
            
            let cityRow: TextRow? = form.rowBy(tag: "city")
            user?.city = cityRow?.value
            
            let countryRow: ButtonRow? = form.rowBy(tag: "country")
            user?.country = countryRow?.value
            user?.countryName = countryRow?.title
        }
    }
}
