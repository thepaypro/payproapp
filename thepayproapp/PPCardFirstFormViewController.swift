//
//  PPCardFirstFormViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 06/07/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

import Eureka

class PPCardFirstFormViewController: FormViewController
{
    var proAccountSelected : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTapped))
        self.navigationItem.rightBarButtonItem = nextButton
        nextButton.isEnabled = false
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textField?.font = UIFont.systemFont(ofSize: 17)
            cell.textField?.adjustsFontSizeToFitWidth = true
            cell.textField?.minimumFontSize = 14.0
            cell.textField?.addTarget(self, action: #selector(self.textfieldEdited), for: .editingChanged)
        }
        
        form +++
            
            Section()
            
            <<< TextRow() {
                $0.tag = "forename"
                $0.title = "Forename"
                $0.placeholder = "mandatory"
                
                $0.add(rule: RuleRequired())
            }
            
            <<< TextRow() {
                $0.tag = "lastname"
                $0.title = "Lastname"
                $0.placeholder = "mandatory"
                
                $0.add(rule: RuleRequired())
            }
        
            <<< DateRow () {
                $0.tag = "dateOfBirth"
                $0.title = "Date of birth"
                $0.value = Date()
                $0.maximumDate = Date()
            }
        
            <<< PickerInputRow<String>("Picker Input Row"){
                $0.tag = "documentType"
                $0.title = "Document type"
                $0.options = ["Driving Licence", "Passport", "National ID Card"]
                $0.value = $0.options.first
            }
            
            <<< TextRow() {
                $0.tag = "documentNumber"
                $0.title = "Document number"
                $0.placeholder = "mandatory"
                
                $0.add(rule: RuleRequired())
            }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextTapped ()
    {
        if form.validate().count == 0
        {
            performSegue(withIdentifier: "showSecondFormVCSegue", sender: self)
        }
        else
        {
            print("EMPTY MANDATORY FIELDS")
        }
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
        
        if segue.identifier == "showSecondFormVCSegue"
        {
            let user = User.currentUser()
            
            let forenameRow: TextRow? = form.rowBy(tag: "forename")
            user?.forename = forenameRow?.value
            
            let lastNameRow: TextRow? = form.rowBy(tag: "lastname")
            user?.lastname = lastNameRow?.value
            
            let dateOfBirthRow : DateRow? = form.rowBy(tag: "dateOfBirth")
            user?.dob = dateOfBirthRow?.value?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            
            let documentTypeRow: PickerInputRow<String>? = form.rowBy(tag: "documentType")
            
            if documentTypeRow?.value == "Driving Licence" {
                user?.documentType = "DRIVING_LICENSE"
            } else if documentTypeRow?.value == "National ID Card" {
                user?.documentType = "DNI"
            } else if documentTypeRow?.value == "Passport" {
                user?.documentType = "PASSPORT"
            }
            
            let documentNumberRow: TextRow? = form.rowBy(tag: "documentNumber")
            user?.documentNumber = documentNumberRow?.value
        }
    }

}
