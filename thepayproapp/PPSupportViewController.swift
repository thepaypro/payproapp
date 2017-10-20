//
//  PPSupportViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 29/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit
import Intercom

class PPSupportViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.title = "Support"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let when = DispatchTime.now() + 0.1

        DispatchQueue.main.asyncAfter(deadline: when) {
            self.tabBarController?.selectedIndex = 3
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Intercom.presentMessenger()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
