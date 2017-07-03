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
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setTabView()

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
        let supportViewController = storyboard.instantiateViewController(withIdentifier: "TPPSupportNavigationController")
        let groupsViewController = storyboard.instantiateViewController(withIdentifier: "TPPGroupsNavigationController")
        let sendViewController = storyboard.instantiateViewController(withIdentifier: "TPPSendMoneyNavigationController")
//        let accountViewController = storyboard.instantiateViewController(withIdentifier: "TPPAccountNavigationController")
        let demoViewController = storyboard.instantiateViewController(withIdentifier: "TPPDemoAccountNavigationController")
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "TPPSettingsNavigationController")
        
        self.viewControllers = [supportViewController, groupsViewController, sendViewController, demoViewController, settingsViewController]
    }
    
    func setTabView()
    {
        self.tabBar.tintColor = PayProColors.blue
    }
    
    func loadAmountTabItem()
    {
        let tabBarController: UITabBarController = (UIApplication.shared.keyWindow?.rootViewController as? UITabBarController)!
        tabBarController.selectedIndex = 3
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
