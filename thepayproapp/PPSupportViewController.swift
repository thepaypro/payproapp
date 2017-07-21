//
//  PPSupportViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 29/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPSupportViewController: UIViewController
{
    @IBOutlet weak var chatWV: UIWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Support"
        
        // Do any additional setup after loading the view.
        
        if User.currentUser()?.supportChatId != 0
        {
            self.loadSupportChat()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func loadSupportChat()
    {
        let chatURL = "https://www.mensaxe.com/webview/\((User.currentUser()?.supportChatId)!)?key=kprvd6suDOTedUX9xN3hc4EiDKHnLEvTBmsJuj"
        
        if let url = URL(string: chatURL)
        {
            let request = URLRequest(url: url)
            chatWV.loadRequest(request)
        }
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
