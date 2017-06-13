//
//  TPPTabBarController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 13/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class TPPTabBarController: UITabBarController
{
    convenience init()
    {
        self.init(nibName:nil, bundle:nil)
        
        self.setTabControllers()
        
        self.setTabView()
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTabControllers()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // create view controllers from storyboard
        let supportViewController = storyboard.instantiateViewController(withIdentifier: "SupportNavViewControllerId")
        let groupsViewController = storyboard.instantiateViewController(withIdentifier: "GroupsNavViewControllerId")
        let sendViewController = storyboard.instantiateViewController(withIdentifier: "SendMoneyNavViewControllerId")
//        let accountViewController = storyboard.instantiateViewController(withIdentifier: "AccountNavViewControllerId")
        let demoViewController = storyboard.instantiateViewController(withIdentifier: "DemoNavViewControllerId")
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsNavViewControllerId")
        
        self.viewControllers = [supportViewController, groupsViewController, sendViewController, demoViewController, settingsViewController]
    }
    
    func setTabView()
    {
        self.tabBar.tintColor = PayProColors.blue
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
