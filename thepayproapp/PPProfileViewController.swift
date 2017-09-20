//
//  PPProfileViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 23/6/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit
import CoreData

class PPProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nationalView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBAction func avatarButtonAction(_ sender: Any) {
        avatarAlert()
    }
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var documentLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var numberBuildingLabel: UILabel!
    @IBOutlet weak var postCodeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let avatarBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let avatarLayerTop = CAShapeLayer()
        avatarLayerTop.path = avatarBorderTop.cgPath
        avatarLayerTop.fillColor = PayProColors.line.cgColor
        self.avatarView.layer.addSublayer(avatarLayerTop)
        
        let avatarBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 75.6, width: self.view.frame.width, height: 0.4))
        let avatarLayerBottom = CAShapeLayer()
        avatarLayerBottom.path = avatarBorderBottom.cgPath
        avatarLayerBottom.fillColor = PayProColors.line.cgColor
        self.avatarView.layer.addSublayer(avatarLayerBottom)

        
        let nameBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let nameLayerTop = CAShapeLayer()
        nameLayerTop.path = nameBorderTop.cgPath
        nameLayerTop.fillColor = PayProColors.line.cgColor
        self.nameView.layer.addSublayer(nameLayerTop)
        
        let nameBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 43.6, width: self.view.frame.width, height: 0.4))
        let nameLayerBottom = CAShapeLayer()
        nameLayerBottom.path = nameBorderBottom.cgPath
        nameLayerBottom.fillColor = PayProColors.line.cgColor
        self.nameView.layer.addSublayer(nameLayerBottom)
        
        
        let nationalBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let nationalLayerTop = CAShapeLayer()
        nationalLayerTop.path = nationalBorderTop.cgPath
        nationalLayerTop.fillColor = PayProColors.line.cgColor
        self.nationalView.layer.addSublayer(nationalLayerTop)
        
        let nationalBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 43.6, width: self.view.frame.width, height: 0.4))
        let nationalLayerBottom = CAShapeLayer()
        nationalLayerBottom.path = nationalBorderBottom.cgPath
        nationalLayerBottom.fillColor = PayProColors.line.cgColor
        self.nationalView.layer.addSublayer(nationalLayerBottom)
        
        
        let addressBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let addressLayerTop = CAShapeLayer()
        addressLayerTop.path = addressBorderTop.cgPath
        addressLayerTop.fillColor = PayProColors.line.cgColor
        self.addressView.layer.addSublayer(addressLayerTop)
        
        let addressBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 119.6, width: self.view.frame.width, height: 0.4))
        let addressLayerBottom = CAShapeLayer()
        addressLayerBottom.path = addressBorderBottom.cgPath
        addressLayerBottom.fillColor = PayProColors.line.cgColor
        self.addressView.layer.addSublayer(addressLayerBottom)

        
        let infoBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let infoLayerTop = CAShapeLayer()
        infoLayerTop.path = infoBorderTop.cgPath
        infoLayerTop.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerTop)
        
        let infoBorderMiddle = UIBezierPath(rect: CGRect(x: 15, y: 43.6, width: self.view.frame.width, height: 0.4))
        let infoLayerMiddle = CAShapeLayer()
        infoLayerMiddle.path = infoBorderMiddle.cgPath
        infoLayerMiddle.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerMiddle)
        
        let infoBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 87.6, width: self.view.frame.width, height: 0.4))
        let infoLayerBottom = CAShapeLayer()
        infoLayerBottom.path = infoBorderBottom.cgPath
        infoLayerBottom.fillColor = PayProColors.line.cgColor
        self.infoView.layer.addSublayer(infoLayerBottom)
        
        self.setupView()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupView()
    }
    
    func setupView()
    {
        //rounded avatar image
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width/2
        avatarImage.clipsToBounds = true
        
        var data:NSData?
        data = UserDefaults.standard.object(forKey: "avatar") as? NSData
        
        if data != nil
        {
            avatarImage.contentMode = .scaleToFill
            avatarImage.image = UIImage(data: data! as Data)
        } else {
            avatarImage.contentMode = .scaleToFill
            avatarImage.image = UIImage(named:"default-profile")
        }
        
        let user = User.currentUser()
        
        if user?.status == User.Status.statusActivating ||
            user?.status == User.Status.statusActivated {
            self.nameLabel.text = (user?.forename)!+" "+(user?.lastname)!
            self.documentLabel.text = user?.documentNumber
            self.streetLabel.text = user?.street
            self.numberBuildingLabel.text = user?.buildingNumber
            self.postCodeLabel.text = user?.postCode
            self.cityLabel.text = user?.city
            self.countryLabel.text = user?.country
            self.phoneNumberLabel.text = user?.username
            self.emailLabel.text = user?.email
        }
    }
    
    func avatarAlert()
    {
        let alert = UIAlertController(title: "Edit avatar", message: "", preferredStyle: .actionSheet)
        
        let cameraButtonAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            print("Camera button pressed")
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("problems with open camera")
            }
            
//            self.dismiss(animated: true, completion: {
//                self.performSegue(withIdentifier: "sendMoneyInAppSegue", sender: self)
//            })
        })
        
        alert.addAction(cameraButtonAction)
        
        let libraryButtonAction = UIAlertAction(title: "Library", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            print("Library button pressed")
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        alert.addAction(libraryButtonAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.sourceView = avatarView
        alert.popoverPresentationController?.sourceRect = avatarView.bounds
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if ((info[UIImagePickerControllerEditedImage] as? UIImage) != nil) {
            pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        }
        
        prepareImageForSaving(image: pickedImage!)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func prepareImageForSaving(image:UIImage)
    {
        guard let imageData  = UIImageJPEGRepresentation(image, 0.7) else {
            print("jpg error")
            return
        }
        
        UserDefaults.standard.setValue(imageData, forKey: "avatar")
        
        let data = UserDefaults.standard.object(forKey: "avatar") as! NSData
        
        avatarImage.contentMode = .scaleToFill
        avatarImage.image = UIImage(data: data as Data)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUpdateAddressSegue" {
            let updateAddressVC = segue.destination as! PPCardSecondFormViewController
            updateAddressVC.updateAccount = true
        }
    }
}
