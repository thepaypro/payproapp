//
//  RouterViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 6/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class RouterViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAccountViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func loadAccountViewController(){
        
        let vc:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "demoview")
        
        self.navigationController?.setViewControllers([vc], animated:false)
    }
}
