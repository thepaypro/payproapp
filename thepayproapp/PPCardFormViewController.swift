//
//  PPCardFormViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 06/07/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPCardFormViewController: UIViewController
{
    var proAccountSelected : Bool = false
    
    @IBOutlet weak var forenameTF: UITextField!
    @IBOutlet weak var lastnameTF: UITextField!
    @IBOutlet weak var dateOfBirthTF: UITextField!
    @IBOutlet weak var documentTypeTF: UITextField!    
    @IBOutlet weak var documentNumberTF: UITextField!
    @IBOutlet weak var address1TF: UITextField!
    @IBOutlet weak var address2TF: UITextField!
    @IBOutlet weak var postcodeTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
