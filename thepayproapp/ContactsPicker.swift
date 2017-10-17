//
//  ContactsPicker.swift
//  thepayproapp
//
//  Created by Enric Giribet on 16/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit
import Contacts


public protocol PickerDelegate: class {
    func ContactPicker(_: ContactsPicker, didContactFetchFailed error: NSError)
    func ContactPicker(_: ContactsPicker, didCancel error: NSError)
    func ContactPicker(_: ContactsPicker, didSelectContact contact: Contact)
    func ContactPicker(_: ContactsPicker, didSelectMultipleContacts contacts: [Contact])
    func ContacPickerNotInList(controller:ContactsPicker)
//    func ContactBankTransfer(contact: Contact)
    func ContactInvite(contact: Contact)
    func ContactSendInApp(contact: Contact)
    func ContactIntroduceBitcoinAddress()
}

//public extension PickerDelegate {
//    func ContactPicker(_: ContactsPicker, didContactFetchFailed error: NSError) { }
//    func ContactPicker(_: ContactsPicker, didCancel error: NSError) { }
//    func ContactPicker(_: ContactsPicker, didSelectContact contact: Contact) { }
//    func ContactPicker(_: ContactsPicker, didSelectMultipleContacts contacts: [Contact]) { }
//    func ContacPickerNotInList(controller:ContactsPicker) { }
////    func ContactBankTransfer(contact: Contact) { }
//    func ContactInvite(contact: Contact) { }
//    func ContactSendInApp(contact: Contact) { }
//    func ContactIntroduceBitcoinAddress() { }
//}

typealias ContactsHandler = (_ contacts : [CNContact] , _ error : NSError?) -> Void

public enum SubtitleCellValue{
    case phoneNumber
    case email
    case birthday
    case organization
}

open class ContactsPicker: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: - Properties
    
    open weak var contactDelegate: PickerDelegate?
    var contactsStore: CNContactStore?
    var resultSearchController = UISearchController()
    var orderedContacts = [String: [CNContact]]() //Contacts ordered in dicitonary alphabetically
    var sortedContactKeys = [String]()
    var validateContacts = NSDictionary() //Contacts received from backend before checked
    
    var selectedContacts = [Contact]()
    var filteredContacts = [CNContact]()
    
    var subtitleCellValue = SubtitleCellValue.phoneNumber
    var multiSelectEnabled: Bool = false //Default is single selection contact
    
    // MARK: - Lifecycle Methods
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.title = GlobalConstants.Strings.contactsTitle
        
        registerContactCell()
        inititlizeBarButtons()
        initializeSearchBar()
        reloadContacts()
    }
    
    func initializeSearchBar() {
        self.resultSearchController = ( {
            let box = UIView()
//            box.frame = CGRect(x: 0, y:0, width: self.tableView.frame.width , height: 88)
            box.frame = CGRect(x: 0, y:0, width: self.tableView.frame.width , height: 44)
            box.backgroundColor = UIColor.clear
            
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.delegate = self
            controller.searchBar.frame.size.width = box.frame.width - 15
            
//            self.tableView.tableHeaderView = controller.searchBar
            
            box.addSubview(controller.searchBar)
            
//            let notInContactList = UIView()
//            notInContactList.frame = CGRect(x: 0, y:44, width: box.frame.width , height: 44)
//            
//            let button = UIButton()
//            button.frame = CGRect(x:0, y:0, width: box.frame.width, height: 44)
//            button.backgroundColor = UIColor.clear
//            button.addTarget(self, action: #selector(pressNotInMyContactList), for: .touchUpInside)
//            
//            notInContactList.addSubview(button)
//            
//            let plusImage = UIImage(named: "contactAdd")
//            let plusImageView = UIImageView(image: plusImage!)
//            plusImageView.frame = CGRect(x:15, y: 8, width: 29, height: 29)
//            
//            notInContactList.addSubview(plusImageView)
//            
//            let label = UILabel()
//            label.text = "Not in my contact list"
//            label.textAlignment = .center
//            label.textColor = PayProColors.blue
//            label.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
//            label.frame = CGRect(x: 40, y: 12, width: 200, height: 20)
//            
//            notInContactList.addSubview(label)
//            
//            box.addSubview(notInContactList)
            
            self.tableView.tableHeaderView = box
            return controller
        })()
    }
    
    func pressNotInMyContactList()
    {
        contactDelegate?.ContacPickerNotInList(controller: self)
    }
    
    func inititlizeBarButtons() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(onTouchCancelButton))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        if multiSelectEnabled {
            let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(onTouchDoneButton))
            self.navigationItem.rightBarButtonItem = doneButton
            
        }
    }
    
    fileprivate func registerContactCell() {
        
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: GlobalConstants.Strings.bundleIdentifier, withExtension: "bundle") {
            
            if let bundle = Bundle(url: bundleURL) {
                
                let cellNib = UINib(nibName: GlobalConstants.Strings.cellNibIdentifier, bundle: bundle)
                tableView.register(cellNib, forCellReuseIdentifier: "Cell")
            }
            else {
                assertionFailure("Could not load bundle")
            }
        }
        else {
            
            let cellNib = UINib(nibName: GlobalConstants.Strings.cellNibIdentifier, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: "Cell")
        }
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initializers
    
    convenience public init(delegate: PickerDelegate?) {
        self.init(delegate: delegate, multiSelection: false)
    }
    
    convenience public init(delegate: PickerDelegate?, multiSelection : Bool) {
        self.init(style: .plain)
        self.multiSelectEnabled = multiSelection
        contactDelegate = delegate
    }
    
    convenience public init(delegate: PickerDelegate?, multiSelection : Bool, subtitleCellType: SubtitleCellValue) {
        self.init(style: .plain)
        self.multiSelectEnabled = multiSelection
        contactDelegate = delegate
        subtitleCellValue = subtitleCellType
    }
    
    
    // MARK: - Contact Operations
    
    open func reloadContacts() {
        getContacts( {(contacts, error) in
            if (error == nil) {
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    func getContacts(_ completion:  @escaping ContactsHandler) {
        if contactsStore == nil {
            //ContactStore is control for accessing the Contacts
            contactsStore = CNContactStore()
        }
        let error = NSError(domain: "ContactPickerErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "No Contacts Access"])
        
        switch CNContactStore.authorizationStatus(for: CNEntityType.contacts) {
        case CNAuthorizationStatus.denied, CNAuthorizationStatus.restricted:
            //User has denied the current app to access the contacts.
            
            let productName = Bundle.main.infoDictionary!["CFBundleName"]!
            
            let alert = UIAlertController(title: "Unable to access contacts", message: "\(productName) does not have access to contacts. Kindly enable it in privacy settings ", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {  action in
                completion([], error)
                self.dismiss(animated: true, completion: {
                    self.contactDelegate?.ContactPicker(self, didContactFetchFailed: error)
                })
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        case CNAuthorizationStatus.notDetermined:
            //This case means the user is prompted for the first time for allowing contacts
            contactsStore?.requestAccess(for: CNEntityType.contacts, completionHandler: { (granted, error) -> Void in
                //At this point an alert is provided to the user to provide access to contacts. This will get invoked if a user responds to the alert
                if  (!granted ){
                    DispatchQueue.main.async(execute: { () -> Void in
                        completion([], error! as NSError?)
                    })
                }
                else{
                    self.getContacts(completion)
                }
            })
            
        case  CNAuthorizationStatus.authorized:
            //Authorization granted by user for this app.
            var contactsArray = [CNContact]()
            
            let contactFetchRequest = CNContactFetchRequest(keysToFetch: allowedContactKeys())
            
            do {
                try contactsStore?.enumerateContacts(with: contactFetchRequest, usingBlock: { (contact, stop) -> Void in
                    //Ordering contacts based on alphabets in firstname
                    contactsArray.append(contact)
                    var key: String = "#"
                    //If ordering has to be happening via family name change it here.
                    if let firstLetter = contact.givenName[0..<1] , firstLetter.containsAlphabets() {
                        key = firstLetter.uppercased()
                    }
                    var contacts = [CNContact]()
                    
                    if let segregatedContact = self.orderedContacts[key] {
                        contacts = segregatedContact
                    }
                    contacts.append(contact)
                    self.orderedContacts[key] = contacts
                    
                })
                self.sortedContactKeys = Array(self.orderedContacts.keys).sorted(by: <)
                if self.sortedContactKeys.first == "#" {
                    self.sortedContactKeys.removeFirst()
                    self.sortedContactKeys.append("#")
                }
                
                //make phonenumber array to send back for check if phone is app user
                var phoneNumberArray:[String:String] = [:]
                var position = 0
                
                for c in contactsArray {
                    for phoneNumber in c.phoneNumbers {
                        phoneNumberArray["\(position)"] = phoneNumber.value.stringValue.replacingOccurrences(of: "[^\\d+]", with: "", options: [.regularExpression])
                        position += 1
                    }
                }
                self.displayNavBarActivity()
                checkContacts(contacts: phoneNumberArray as NSDictionary, completion: {contactsResponse in
                    
                    if contactsResponse["status"] as! Bool == true {
                        
                        let contacts: NSDictionary = contactsResponse["contacts"] as! NSDictionary

                        if contacts.count > 0 {
                            self.validateContacts = contacts
                        }
                    } else if let errorMessage = contactsResponse["errorMessage"] {
                        let alert = UIAlertController()
                        self.present(alert.displayAlert(code: errorMessage as! String), animated: true, completion: nil)
                    }
                    self.dismissNavBarActivity()
                    completion(contactsArray, nil)
                })
            }
                
            //Catching exception as enumerateContactsWithFetchRequest can throw errors
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func allowedContactKeys() -> [CNKeyDescriptor]{
        //We have to provide only the keys which we have to access. We should avoid unnecessary keys when fetching the contact. Reducing the keys means faster the access.
        return [CNContactNamePrefixKey as CNKeyDescriptor,
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactOrganizationNameKey as CNKeyDescriptor,
                CNContactBirthdayKey as CNKeyDescriptor,
                CNContactImageDataKey as CNKeyDescriptor,
                CNContactThumbnailImageDataKey as CNKeyDescriptor,
                CNContactImageDataAvailableKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactEmailAddressesKey as CNKeyDescriptor,
        ]
//        return [CNContactNamePrefixKey as CNKeyDescriptor,
//                CNContactGivenNameKey as CNKeyDescriptor,
//                CNContactImageDataKey as CNKeyDescriptor,
//                CNContactThumbnailImageDataKey as CNKeyDescriptor,
//                CNContactImageDataAvailableKey as CNKeyDescriptor,
//                CNContactPhoneNumbersKey as CNKeyDescriptor,
//        ]
    }
    
    // MARK: - Table View DataSource
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        if resultSearchController.isActive { return 1 }
        return sortedContactKeys.count
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.isActive { return filteredContacts.count }
        if let contactsForSection = orderedContacts[sortedContactKeys[section]] {
            return contactsForSection.count
        }
        return 0
    }
    
    // MARK: - Table View Delegates
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContactCell
        cell.accessoryType = UITableViewCellAccessoryType.none
        //Convert CNContact to Contact
        let contact: Contact
        
        if resultSearchController.isActive {
            contact = Contact(contact: filteredContacts[(indexPath as NSIndexPath).row])
        } else {
            guard let contactsForSection = orderedContacts[sortedContactKeys[(indexPath as NSIndexPath).section]] else {
                assertionFailure()
                return UITableViewCell()
            }

            contact = Contact(contact: contactsForSection[(indexPath as NSIndexPath).row])
        }
        
        if multiSelectEnabled  && selectedContacts.contains(where: { $0.userId == contact.userId }) {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }

        cell.updateContactsinUI(contact, validateContacts: self.validateContacts, indexPath: indexPath, subtitleType: subtitleCellValue)
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ContactCell
        let selectedContact =  cell.contact!
        if multiSelectEnabled {
            //Keeps track of enable=ing and disabling contacts
            if cell.accessoryType == UITableViewCellAccessoryType.checkmark {
                cell.accessoryType = UITableViewCellAccessoryType.none
                selectedContacts = selectedContacts.filter(){
                    return selectedContact.userId != $0.userId
                }
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
                selectedContacts.append(selectedContact)
            }
        }
        else {
            //Single selection code
            resultSearchController.isActive = false
//            self.contactDelegate?.ContactPicker(self, didSelectContact: selectedContact)
            
            if selectedContact.getIsPayProUser() == false {
                let alert = UIAlertController(title: "Send money by", message: "", preferredStyle: .actionSheet)
                
//                let bankTransfeButtonAction = UIAlertAction(title: "Bank transfer", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
//                    self.contactDelegate?.ContactBankTransfer(contact: selectedContact)
//                })
//                alert.addAction(bankTransfeButtonAction)
                
                let introduceBitcoinAddressAction = UIAlertAction(title: "Introduce Bitcoin Address", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                    self.contactDelegate?.ContactIntroduceBitcoinAddress()
                })
                
                alert.addAction(introduceBitcoinAddressAction)
                
                let inviteButtonAction = UIAlertAction(title: "Invite someone to PayPro", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                    self.contactDelegate?.ContactInvite(contact: selectedContact)
                })
                
                alert.addAction(inviteButtonAction)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alert.addAction(cancelAction)
                
                alert.popoverPresentationController?.sourceView = tableView
                alert.popoverPresentationController?.sourceRect = tableView.rectForRow(at: indexPath)
                
                self.present(alert, animated: true, completion: nil)
                
            }else if selectedContact.getIsPayProUser() == true {
                //enabled block load process
                self.contactDelegate?.ContactSendInApp(contact: selectedContact)
            }

            
        }
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if resultSearchController.isActive { return 0 }
        tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: UITableViewScrollPosition.top , animated: false)
        return sortedContactKeys.index(of: title)!
    }
    
    override  open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if resultSearchController.isActive { return nil }
        return sortedContactKeys
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if resultSearchController.isActive { return nil }
        return sortedContactKeys[section]
    }
    
    // MARK: - Button Actions
    
    func onTouchCancelButton() {
//        dismiss(animated: true, completion: {
//            self.contactDelegate?.ContactPicker(self, didCancel: NSError(domain: "EPContactPickerErrorDomain", code: 2, userInfo: [ NSLocalizedDescriptionKey: "User Canceled Selection"]))
//        })
        self.contactDelegate?.ContactPicker(self, didCancel: NSError(domain: "EPContactPickerErrorDomain", code: 2, userInfo: [ NSLocalizedDescriptionKey: "User Canceled Selection"]))
    }
    
    func onTouchDoneButton() {
        dismiss(animated: true, completion: {
            self.contactDelegate?.ContactPicker(self, didSelectMultipleContacts: self.selectedContacts)
        })
    }
    
    // MARK: - Search Actions
    
    open func updateSearchResults(for searchController: UISearchController)
    {
        if let searchText = resultSearchController.searchBar.text , searchController.isActive {
            
            let predicate: NSPredicate
            if searchText.characters.count > 0 {
                predicate = CNContact.predicateForContacts(matchingName: searchText)
            } else {
                predicate = CNContact.predicateForContactsInContainer(withIdentifier: contactsStore!.defaultContainerIdentifier())
            }
            
            let store = CNContactStore()
            do {
                filteredContacts = try store.unifiedContacts(matching: predicate, keysToFetch: allowedContactKeys())
                
                self.tableView.reloadData()
            }
            catch {
                print("Error!")
            }
        }
    }
    
    open func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
}

