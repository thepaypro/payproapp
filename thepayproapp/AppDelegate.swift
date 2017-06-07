//
//  AppDelegate.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 30/05/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // create UIWindow with the same size as main screen
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // create story board. Default story board will be named as Main.storyboard in your project.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // create view controllers from storyboard
        let supportViewController = storyboard.instantiateViewController(withIdentifier: "SupportNavViewControllerId")
        let groupsViewController = storyboard.instantiateViewController(withIdentifier: "GroupsNavViewControllerId")
        let sendViewController = storyboard.instantiateViewController(withIdentifier: "SendMoneyNavViewControllerId")
//        let accountViewController = storyboard.instantiateViewController(withIdentifier: "AccountNavViewControllerId")
        let demoViewController = storyboard.instantiateViewController(withIdentifier: "DemoNavViewControllerId")
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsNavViewControllerId")
        
        // Set up the Tab Bar Controller to have two tabs
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [supportViewController, groupsViewController, sendViewController, demoViewController, settingsViewController]
        tabBarController.tabBar.tintColor = PayProColors.blue
        
        // Make the Tab Bar Controller the root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

