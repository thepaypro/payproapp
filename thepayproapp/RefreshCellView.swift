//
//  RefreshCellView.swift
//  AutoLoad
//
//  Created by Roger Baiget on 4/10/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class RefreshCellView : UITableViewCell
{
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        label.text = "Loading more data"
    }
    
    func startLoading(){
        label.text = "Loading more data"
        loader.startAnimating()
    }
    
    func stopLoading(){
        loader.stopAnimating()
    }
    
    func updateText(text: String){
        label.text = text
    }
    
    func hideLoader(){
        self.loader.isHidden = true
        self.label.isHidden = true
//        self.height.constant = 20
        self.stopLoading()
        
    }
    
    func showLoader(){
        self.loader.isHidden = false
        self.label.isHidden = false
//        self.height.constant = 76
        self.startLoading()
    }
    
    func isVisible() -> Bool {
        return !self.loader.isHidden
    }
}
