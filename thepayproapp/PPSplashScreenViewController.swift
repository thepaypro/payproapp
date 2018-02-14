//
//  PPSplashScreenViewController.swift
//  thepayproapp
//
//  Created by Roger Baiget on 14/2/18.
//  Copyright © 2018 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPSplashScreenViewController: UIViewController{
    
    var destination: UIViewController?
    var logoImageView: UIImageView?
    let alert = UIAlertController(title: "Update Avaliable", message: "You need to update the app in order to keep using it", preferredStyle: .alert);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector:#selector(checkVersion), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkVersion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkVersion(){
        CheckVersion { (response) in
            if(response["need_update"] as! Bool){
                self.alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: { alertAction in
                    UIApplication.shared.open(URL(string : "https://itunes.apple.com/us/app/paypro/id1225181484?l=ca&ls=1&mt=8")!)
                }))
                self.present(self.alert, animated: true, completion: nil)
            }else{
                self.alert.dismiss(animated: true, completion: nil)
                if User.currentUser() != nil{
                    self.performSegue(withIdentifier: "passcodeSegue", sender: self)
                }else{
                     self.performSegue(withIdentifier: "wellcomeSegue", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "passcodeSegue"{
            let passcodeVC : PPPasscodeViewController = segue.destination as! PPPasscodeViewController
            passcodeVC.userUsername = User.currentUser()?.username
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
