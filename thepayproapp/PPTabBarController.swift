//
//  PPTabBarController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 13/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPTabBarController: UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setTabView()

        self.setTabControllers()
        
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
        let supportNC = storyboard.instantiateViewController(withIdentifier: "PPSupportNavigationController") as! UINavigationController
        
        let supportVC = supportNC.viewControllers.first as! PPSupportViewController
        
        if User.currentUser()?.supportChatId == nil
        {
            User.supportChat(languageCode: Locale.current.languageCode!) { (supportChatId) in
                supportVC.loadSupportChat()
            }
        }
        
        let groupsNC = storyboard.instantiateViewController(withIdentifier: "PPGroupsNavigationController")
        let sendNC = storyboard.instantiateViewController(withIdentifier: "PPSendMoneyNavigationController")
        
//        let userAccountType = User.currentUser()?.accountType
        var accountNC = storyboard.instantiateViewController(withIdentifier: "PPAccountNavigationController")
        
//        if userAccountType == .demoAccount
//        {
            accountNC = storyboard.instantiateViewController(withIdentifier: "PPDemoAccountNavigationController")
//        }
        
        let settingsNC = storyboard.instantiateViewController(withIdentifier: "PPSettingsNavigationController")
        
        self.viewControllers = [supportNC, groupsNC, sendNC, accountNC, settingsNC]
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
