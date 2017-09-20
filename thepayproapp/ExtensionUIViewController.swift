//
//  ExtensionUIViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 26/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func displayNavBarActivity() -> [UIBarButtonItem]? {
        let viewActivityIndicator = UIView()
        viewActivityIndicator.frame = CGRect(x: 0, y: 0, width: 43, height: 43)
        viewActivityIndicator.backgroundColor = UIColor.clear
        
        let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = viewActivityIndicator.center
        activityIndicator.startAnimating()
        
        viewActivityIndicator.addSubview(activityIndicator)
        
        let item = UIBarButtonItem(customView: viewActivityIndicator)
        
        let barButtonItems: [UIBarButtonItem]? = self.navigationItem.rightBarButtonItems
        self.navigationItem.rightBarButtonItem = item
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        return barButtonItems
    }
    
    func dismissNavBarActivity() {
        self.navigationItem.rightBarButtonItem = nil
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
