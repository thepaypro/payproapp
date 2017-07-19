//
//  PPTransactionTableViewCell.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 13/07/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPTransactionTableViewCell: UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setTransaction(transaction: Transaction)
    {
        titleLabel.text = transaction.title
        subtitleLabel.text = transaction.subtitle
        datetimeLabel.text = transaction.datetime
        
        quantityLabel.text = "£\(abs(transaction.amount))"
        
        if transaction.amount < 0
        {
            quantityLabel.text = "-\(quantityLabel.text!)"
        }
    }
}
