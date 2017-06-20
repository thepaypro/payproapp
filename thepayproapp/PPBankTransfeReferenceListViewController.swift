//
//  PPBankTransfeReferenceListViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 20/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

protocol ReferenceViewControllerDelegate: class {
    func referenceSelected(controller:PPBankTransfeReferenceListViewController,text:String?)
}

class PPBankTransfeReferenceListViewController: UITableViewController
{
    weak var delegate: ReferenceViewControllerDelegate?
    
    //created a string array to display on table view
    var tableItems = [
        "Auction (eBay)",
        "Gifts",
        "Mail order",
        "Bill",
        "Other",
        "Auction (Other)",
        "Auction (QXL)",
        "Auction (eBid)",
        "I.O.U",
        "Goods",
        "Service",
        "Days Out",
        "Eating Out",
        "Nights Out",
        "Taxi"
    ]
    
    var itemSelected:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //this method will populate the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableRow = tableView.dequeueReusableCell(withIdentifier: "referenceTableCell") as UITableViewCell!
        
        print(tableRow ?? "nada de nada")
        
        //adding the item to table row
        tableRow?.textLabel?.text = tableItems[indexPath.row]
        
        return tableRow!
    }
    
    
    //this method will return the total rows count in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        
        //getting the current cell from the index path
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        //getting the text of that cell
        let currentItem = currentCell.textLabel!.text

        delegate?.referenceSelected(controller: self, text: currentItem)
        
//        self.performSegue(withIdentifier: "segueReferenceList", sender: self)
        
        _ = navigationController?.popViewController(animated: true)
    }
}
