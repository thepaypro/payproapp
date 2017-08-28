//
//  PPSupportViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 29/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPSupportViewController: UIViewController, UIWebViewDelegate
{
    @IBOutlet weak var webView: UIWebView!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.webView.delegate = self
        
        self.title = "Support"
        
        // Do any additional setup after loading the view.
        
        if User.currentUser()?.supportChatId == 0
        {
            User.supportChat(languageCode: Locale.current.languageCode!) { (supportChatId) in
                self.loadSupportChat()
            }
        }
        
        if User.currentUser()?.supportChatId != 0
        {
            self.loadSupportChat()
        }
        
        self.webView.addSubview(self.activityIndicator)
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
            webView.loadRequest(request)
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
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        showActivityIndicator()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        hideActivityIndicator()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        showActivityIndicator()
    }
    
    func showActivityIndicator()
    {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func hideActivityIndicator()
    {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
