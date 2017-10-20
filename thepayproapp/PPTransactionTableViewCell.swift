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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Your date format
        
        datetimeLabel.text = dateFormatter.string(from: transaction.datetime!)
        
        
        quantityLabel.text = "£ \(abs(transaction.amount))"
        
        if transaction.isPayer
        {
            quantityLabel.text = "-\(quantityLabel.text!)"
        }
    }
    
    public func setBitcoinTransaction(transaction: BitcoinTransaction)
    {
        titleLabel.text = transaction.title
        subtitleLabel.text = transaction.subtitle
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Your date format
        
        datetimeLabel.text = dateFormatter.string(from: transaction.datetime!)
//        datetimeLabel.text = transaction.datetime as? String
        
        quantityLabel.text = "µ₿ \(abs(transaction.amount))"
        
        if transaction.isPayer
        {
            quantityLabel.text = "-\(quantityLabel.text!)"
        }
    }
}
