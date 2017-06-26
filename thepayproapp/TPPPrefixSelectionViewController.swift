//
//  TPPPrefixSelectionViewController.swift
//  thepayproapp
//
//  Created by Manuel Ortega Cordovilla on 26/06/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

protocol TPPPrefixSelectionDelegate
{
    func didSelectCountryPrefix(countryPrefix: String)
}

class TPPPrefixSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var prefixTV: UITableView!
    
    var countriesPrefixesArray : [AnyObject] = []
    
    var delegate : TPPPrefixSelectionDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        countriesPrefixesArray = CountryPrefixLocalConnection.loadLocalCountriesPrefixes()
        
        self.prefixTV.register(UITableViewCell.self, forCellReuseIdentifier: "PrefixCell")
        
        self.prefixTV.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return countriesPrefixesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrefixCell", for: indexPath)
        
        let country = countriesPrefixesArray[indexPath.row] as AnyObject
        let countryName = country.value(forKey: "name") as! String
        
        let countryPrefixes = country.value(forKey: "callingCodes") as! [AnyObject]
        let firstCountryPrefix = countryPrefixes.first as! String
        
        cell.accessoryType = .disclosureIndicator
        
        cell.textLabel?.text = "\(countryName) +\(firstCountryPrefix)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell != nil
        {
            let country = countriesPrefixesArray[indexPath.row] as AnyObject
            let countryPrefixes = country.value(forKey: "callingCodes") as! [AnyObject]
            let countryPrefix = countryPrefixes.first as! String
            
            self.delegate?.didSelectCountryPrefix(countryPrefix: "+\(countryPrefix)")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
 
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
