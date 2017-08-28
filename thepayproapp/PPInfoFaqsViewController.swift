//
//  PPInfoWebViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 14/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPInfoWebViewController: UIViewController, UIWebViewDelegate
{
    @IBOutlet weak var webView: UIWebView!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var activityFinished = 0
    
    var loadOption = 0

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.webView.delegate = self
        
        var faqsURL = URL(string: "https://www.thepaypro.com")
        
        if loadOption == 0 {
            faqsURL = URL(string: "https://www.thepaypro.com")
            self.title = "FAQs"
            
        } else if loadOption == 1 {
            faqsURL = URL(string: "https://www.thepaypro.com")
            self.title = "Terms & Conditions"
            
        } else if loadOption == 2 {
            faqsURL = URL(string: "http://payproapp.boards.net/")
            self.title = "Community"
            
        } else if loadOption == 3 {
            faqsURL = URL(string: "https://www.thepaypro.com")
            self.title = "About us"
        }
        
        let faqsURLRequest = URLRequest(url: faqsURL!)
        webView.loadRequest(faqsURLRequest)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        if activityFinished == 0 {
            showActivityIndicator()
        }
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
//        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func hideActivityIndicator()
    {
        print("00000")
        activityIndicator.stopAnimating()
//        UIApplication.shared.endIgnoringInteractionEvents()
    }
}


