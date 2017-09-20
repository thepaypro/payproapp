//
//  PPPrefixSelectionViewController.swift
//  thepayproapp
//
//  Created by Roger Baiget Dolcet on 18/09/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

struct CountrySection {
    var countries: [Country] = []
    
    mutating func addCountry(_ country: Country) {
        countries.append(country)
    }
}

public protocol PPPrefixSelectionDelegate: class{
    
    func countryPicker(name: String, alpha2Code: String, callingCodes: String)
}

open class PPPrefixSelectionViewController: UITableViewController{
    
    @IBOutlet var prefixTV: UITableView!
    
    public var showCallingCodes: Bool = false
    
    fileprivate var searchController: UISearchController!
    fileprivate var filteredList = [Country]()
    
    fileprivate var unsourtedCountries : [Country] = Country.loadLocalCountriesPrefixes()
    
    open weak var delegate: PPPrefixSelectionDelegate?
    
    fileprivate let collation = UILocalizedIndexedCollation.current()
        as UILocalizedIndexedCollation
    
    fileprivate var sections: [CountrySection] = []
    fileprivate var initialSections: [CountrySection] = []

    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.initialSections = createSections(countries: unsourtedCountries);
        prefixTV.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        createSearchBar()
        prefixTV.reloadData()
        
        definesPresentationContext = true
    }
    
    // MARK: Methods
    
    fileprivate func createSections(countries: [Country]) -> [CountrySection]{
        
        let countries: [Country] = countries.map { country in
            let country = Country(name: country.name, alpha2Code: country.alpha2Code, callingCodes: country.callingCodes)
            country.section = collation.section(for: country, collationStringSelector: #selector(getter: Country.name))
            return country
        }
        
        // create empty sections
        var sections = [CountrySection]()
        for _ in 0..<self.collation.sectionIndexTitles.count {
            sections.append(CountrySection())
        }
        
        // put each country in a section
        for country in countries {
            sections[country.section!].addCountry(country)
        }
        
        // sort each section
        for section in sections {
            var s = section
            s.countries = collation.sortedArray(from: section.countries, collationStringSelector: #selector(getter: Country.name)) as! [Country]
        }
        
        self.sections = sections
        return sections
    }
    
    fileprivate func createSearchBar() {
        if self.prefixTV.tableHeaderView == nil {
            searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
            prefixTV.tableHeaderView = searchController.searchBar
        }
    }
    
    fileprivate func filter(_ searchText: String) -> [Country] {
        filteredList.removeAll()
        
        initialSections.forEach { (section) -> () in
            var alreadyAppended: Bool = false
            section.countries.forEach({ (country) -> () in
                alreadyAppended = false
                if country.name.characters.count >= searchText.characters.count {
                    let nameCompare = country.name.compare(searchText, options: [.caseInsensitive, .diacriticInsensitive], range: searchText.characters.startIndex ..< searchText.characters.endIndex)
                    if nameCompare == .orderedSame {
                        filteredList.append(country)
                        alreadyAppended = true
                    }
                }
                if country.alpha2Code.characters.count >= searchText.characters.count && !alreadyAppended {
                    let alpha2CodeCompare = country.alpha2Code.compare(searchText, options: [.caseInsensitive, .diacriticInsensitive], range: searchText.characters.startIndex ..< searchText.characters.endIndex)
                    if alpha2CodeCompare == .orderedSame {
                        filteredList.append(country)
                    }
                }
            })
        }
        
        return filteredList
    }
}
// MARK: - Table view data source
extension PPPrefixSelectionViewController {
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].countries.count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var tempCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        
        if tempCell == nil {
            tempCell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        }
        
        let cell: UITableViewCell! = tempCell
        
        let country: Country! = sections[(indexPath as NSIndexPath).section].countries[(indexPath as NSIndexPath).row]
        
        var textLabel = country.name
        if(showCallingCodes){
            textLabel += " (" + country.callingCodes + ")"
        }
        cell.textLabel?.text = textLabel
        
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !sections[section].countries.isEmpty {
            return self.collation.sectionTitles[section] as String
        }
        return ""
    }
    
    override open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return collation.sectionIndexTitles
    }
    
    override open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
            return collation.section(forSectionIndexTitle: index)
    }
}

// MARK: - Table view delegate
extension PPPrefixSelectionViewController {
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let country: Country! = sections[(indexPath as NSIndexPath).section].countries[(indexPath as NSIndexPath).row]
        delegate?.countryPicker(name: country.name, alpha2Code: country.alpha2Code, callingCodes: country.callingCodes)
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - UISearchDisplayDelegate
extension PPPrefixSelectionViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        filter(searchController.searchBar.text!)
        createSections(countries: filteredList)
        prefixTV.reloadData()
    }
}
