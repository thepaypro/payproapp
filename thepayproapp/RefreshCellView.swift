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
}
