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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let user = User.currentUser()

        // Do any additional setup after loading the view.
        
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTapped))
        
        if orderingCard
        {
            nextButton.title = "Confirm"
        }
        
        self.navigationItem.rightBarButtonItem = nextButton
        nextButton.isEnabled = false
        
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
                $0.placeholder = "mandatory"
                $0.baseValue = user?.street
                
                $0.add(rule: RuleRequired())
            }
            
            <<< TextRow() {
                $0.tag = "buildingNumber"
                $0.title = "Building number"
                $0.placeholder = "mandatory"
                $0.baseValue = user?.buildingNumber
                
                $0.add(rule: RuleRequired())
            }
            
            <<< ZipCodeRow() {
                $0.tag = "zipcode"
                $0.title = "Postcode"
                $0.placeholder = "mandatory"
                $0.baseValue = user?.postCode
                
                $0.add(rule: RuleRequired())
            }
            
            <<< TextRow() {
                $0.tag = "city"
                $0.title = "City"
                $0.placeholder = "mandatory"
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.rightBarButtonItem?.isEnabled = form.validate().count == 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextTapped ()
    {
        if form.validate().count == 0
        {
            if orderingCard
            {
                self.displayNavBarActivity()
                
                let user = User.currentUser()
                
                let street: String = (user?.street)!
                let buildingNumber: String = (user?.buildingNumber)!
                let postCode: String = (user?.postCode)!
                let city: String = (user?.city)!
                let countryName: String = (user?.countryName)!
                
                let accountUpdateDictionary = [
                    "street": street,
                    "buildingNumber": buildingNumber,
                    "postcode": postCode,
                    "city": city,
                    "country": countryName
                ] as [String : Any]
                
                AccountUpdate(paramsDictionary: accountUpdateDictionary as NSDictionary, completion: { accountUpdateResponse in
                    self.dismissNavBarActivity()
                    self.navigationController?.popViewController(animated: true)
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
    
    func didSelectCountryPrefix(countryPrefix: String, countryName: String, countryISO2: String)
    {
        let countryRow: ButtonRow? = form.rowBy(tag: "country")
        countryRow?.title = countryName
        countryRow?.value = countryISO2
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
