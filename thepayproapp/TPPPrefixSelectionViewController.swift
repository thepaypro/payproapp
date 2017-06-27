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
    func didSelectCountryPrefix(countryPrefix: String, country: String)
}

class TPPPrefixSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var prefixTV: UITableView!
    
    var countriesPrefixesArray : [AnyObject] = []
    var ukPrefix : AnyObject?
    
    
    var delegate : TPPPrefixSelectionDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        countriesPrefixesArray = CountryPrefixLocalConnection.loadLocalCountriesPrefixes()
        
        ukPrefix = countriesPrefixesArray.first!
        
        countriesPrefixesArray.remove(at: 0)
        
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 1
        }
        
        return countriesPrefixesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrefixCell", for: indexPath)
        
        var country = countriesPrefixesArray[indexPath.row] as AnyObject
        
        if indexPath.section == 0
        {
            country = self.ukPrefix!
        }
        
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
            var country = countriesPrefixesArray[indexPath.row] as AnyObject
            
            if indexPath.section == 0
            {
                country = self.ukPrefix!
            }
            
            let countryPrefixes = country.value(forKey: "callingCodes") as! [AnyObject]
            let countryPrefix = countryPrefixes.first as! String
            let countryISO2 = country.value(forKey: "alpha2Code") as! String
            
            self.delegate?.didSelectCountryPrefix(countryPrefix: "+\(countryPrefix)", country: countryISO2)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if section == 1
        {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
            let label = UILabel(frame: CGRect(x: 15, y: 38, width: tableView.frame.size.width, height: 18))
            
            if #available(iOS 8.2, *)
            {
                label.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)
            }
            else
            {
                label.font = UIFont.systemFont(ofSize: 13)
            }
            
            label.textColor = UIColor.darkGray
            label.text = "MORE COUNTRIES"
            view.addSubview(label)
            view.backgroundColor = UIColor.groupTableViewBackground
            
            return view
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 1
        {
            return 60.0
        }
        
        return 0.0
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
