//
//  TPPSendMoneyViewController.swift
//  payproapp
//
//  Created by Manuel Ortega Cordovilla on 13/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

var classControlProcess = TPPSendMoneyViewController()


class TPPSendMoneyViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("en viewDidLoad de Send Money")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("bbbbbbbbbbbbbbbbbbb")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let contactView = storyboard?.instantiateViewController(withIdentifier: "contactViewID") {
            self.addChildViewController(contactView)
            self.view.addSubview(contactView.view)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func fs() {
        print("wwww")
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
