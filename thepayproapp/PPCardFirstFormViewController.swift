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
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textField?.font = UIFont.systemFont(ofSize: 17)
            cell.textField?.adjustsFontSizeToFitWidth = true
            cell.textField?.minimumFontSize = 14.0
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showSecondFormVCSegue"
        {
            let secondFormVC = segue.destination as! PPCardSecondFormViewController
            secondFormVC.proAccountSelected = self.proAccountSelected
            
            let forenameRow: TextRow? = form.rowBy(tag: "forename")
            let forename: String? = forenameRow?.value
            
            let lastNameRow: TextRow? = form.rowBy(tag: "lastname")
            let lastname: String? = lastNameRow?.value
            
            let dateOfBirthRow : DateRow? = form.rowBy(tag: "dateOfBirth")
            let dateOfBirth : String? = dateOfBirthRow?.value?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            
            let documentTypeRow: PickerInputRow<String>? = form.rowBy(tag: "documentType")
            let documentType: String? = documentTypeRow?.value
            
            let documentNumberRow: TextRow? = form.rowBy(tag: "documentNumber")
            let documentNumber: String? = documentNumberRow?.value
            
            secondFormVC.forename = forename
            secondFormVC.lastname = lastname
            secondFormVC.dateOfBirth = dateOfBirth
            secondFormVC.documentType = documentType
            secondFormVC.documentNumber = documentNumber
        }
    }

}
