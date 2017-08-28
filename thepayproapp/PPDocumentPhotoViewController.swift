//
//  PPDocumentPhotoViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 18/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import ALCameraViewController

class PPDocumentPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var buttonPicked:UIButton?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func firstButtonAction(_ sender: Any) {
        buttonPicked = sender as? UIButton
        openCamera()
    }
    @IBAction func secondButtonAction(_ sender: Any) {
        buttonPicked = sender as? UIButton
        openCamera()
    }
    
    @IBOutlet weak var labelFirstPhoto: UILabel!
    @IBOutlet weak var labelSecondPhoto: UILabel!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var secondPhotoView: UIView!
    
    var firstDocumentBase64: String!
    var secondDocumentBase64: String!
    var updateAccount : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = PayProColors.background
        
        let documentType = User.currentUser()?.documentType
    
        if documentType == "DRIVING_LICENSE" {
            self.titleLabel.text = "TAKE A PHOTO OF FRONT DRIVING CARD"
            self.labelFirstPhoto.text = "Press to take a photo with front view"
            self.labelSecondPhoto.text = "Press to take a photo with back view"
            
        } else if documentType == "DNI" {
            self.titleLabel.text = "TAKE A PHOTO OF FRON NATIONAL CARD"
            self.labelFirstPhoto.text = "Press to take a photo with front view"
            self.labelSecondPhoto.text = "Press to take a photo with back view"
            
        } else if documentType == "PASSPORT" {
            self.secondPhotoView.isHidden = true
            self.titleLabel.text = "TAKE A PHOTO OF PASSPORT"
            self.labelFirstPhoto.text = "Press to take a photo"
        }
        
        let next = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(callEndpoint))
        
        self.navigationItem.setRightBarButtonItems([next], animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupView()
    }
    
    func setupView()
    {
        self.setNavigationBarButton()
    }
    
    func setNavigationBarButton()
    {
        let nextButton = UIBarButtonItem(title: "Confirm", style: .plain, target: self, action: #selector(callEndpoint))
        
        self.navigationItem.rightBarButtonItem = nextButton
        
        self.checkNavigation()
    }
    
    func checkNavigation() {
        let documentType = User.currentUser()?.documentType
        
        if documentType == "DRIVING_LICENSE" && self.firstDocumentBase64 != "" && self.secondDocumentBase64 != "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
        } else if documentType == "DNI" {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
        } else if documentType == "PASSPORT" {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }

    }

    
    func callEndpoint()
    {
        self.displayNavBarActivity()
        
        let user = User.currentUser()
        
        let identifier: Int64 = Int64((User.currentUser()?.identifier)!)
        let documentType: String = (user?.documentType)!
        let documentPicture1 = self.firstDocumentBase64 ?? ""
        let documentPicture2 = self.secondDocumentBase64 ?? ""
        
        if updateAccount == false {
            let agreement: Int = Int((user?.accountType)!.rawValue)
            let forename: String = (user?.forename)!
            let lastname: String = (user?.lastname)!
            let birthDate: String = (user?.dob)!
            let street: String = (user?.street)!
            let buildingNumber: String = (user?.buildingNumber)!
            let postcode: String = (user?.postCode)!
            let city: String = (user?.city)!
            let country: String = (user?.country)!
            let countryName: String = (user?.countryName)!
            
            var deviceToken = ""
            
            if UserDefaults.standard.object(forKey: "deviceToken") != nil {
                deviceToken = UserDefaults.standard.object(forKey: "deviceToken") as! String
            }
        
            AccountCreate(
                agreement: agreement,
                forename: forename,
                lastname: lastname,
                dob: birthDate,
                documentType: documentType,
                street: street,
                buildingNumber: buildingNumber,
                postcode: postcode,
                city: city,
                country: country,
                documentFront: documentPicture1,
                documentBack: documentPicture2,
                deviceToken: deviceToken,
                completion: {successAccountCreate in
                    if successAccountCreate {
                        print("create account success")
                    
                        let userDictionary = [
                            "id": identifier,
                            "status": User.Status.statusActivating.rawValue,
                            "account_type_id": agreement,
                            "forename": forename,
                            "lastname": lastname,
                            "dob": birthDate,
                            "docment_type": documentType,
                            "street": street,
                            "buildingNumber": buildingNumber,
                            "postcode": postcode,
                            "city": city,
                            "country": country,
                            "countryName": countryName
                            ] as [String : Any]
                    
                        let updateUser = User.manage(userDictionary: userDictionary as NSDictionary)
                        if updateUser != nil {
                            print("update user correctly")
                            self.dismissNavBarActivity()
                            self.navigationController?.popToRootViewController(animated: false)
                        } else {
                            self.dismissNavBarActivity()
                            print("update user error")
                        }
                    } else {
                        print("create account problems")
                    }
                }
            )
        } else {
            
            let accountUpdateDictionary = [
                "documentType": documentType,
                "documentPicture1": documentPicture1,
                "documentPicture2": documentPicture2
                ] as [String : Any]
            
            AccountRequestUpdate(paramsDictionary: accountUpdateDictionary as NSDictionary, completion: { accountUpdateResponse in
                
                if accountUpdateResponse["status"] as! Bool == true {
                    let userDictionary = [
                        "id": identifier,
                        "documentType": documentType
                        ] as [String : Any]
                    
                    let updateUser = User.manage(userDictionary: userDictionary as NSDictionary)
                    
                    if updateUser != nil {
                        self.dismissNavBarActivity()
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.dismissNavBarActivity()
                        self.setNavigationBarButton()
                        let alert = UIAlertController()
                        self.present(alert.displayAlert(code: "error_saving"), animated: true, completion: nil)
                    }
                } else {
                    var errorMessage: String = "error_saving"
                    
                    if accountUpdateResponse["errorMessage"] != nil {
                        errorMessage = accountUpdateResponse["errorMessage"] as! String
                    }
                    
                    self.dismissNavBarActivity()
                    self.setNavigationBarButton()
                    let alert = UIAlertController()
                    self.present(alert.displayAlert(code: errorMessage), animated: true, completion: nil)
                }
            })
        }
    }
    
    func openCamera()
    {
        let cameraViewController = CameraViewController(croppingEnabled: true, allowsLibraryAccess: true) { [weak self] image, asset in
            
            if image != nil {
                let w:Int = Int((image?.size.width)!)
                let h:Int = Int((image?.size.height)!)
            
                var newImage: UIImage?
            
                if w < h {
                    newImage = UIImage(cgImage: (image?.cgImage!)!, scale: (image?.scale)!, orientation: UIImageOrientation.left)
                    newImage = newImage?.resized(toWidth: (self?.firstImage.frame.size.width)!)
                } else {
                    newImage = image?.resized(toWidth: (self?.firstImage.frame.size.width)!)
                }
            
                guard let imageData  = UIImageJPEGRepresentation(newImage!, 1.0) else {
                    print("jpg error")
                    return
                }
            
                let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            
                if self?.buttonPicked?.tag == 0 {
                
                    self?.firstImage.image = newImage
                    self?.firstDocumentBase64 = strBase64
                
                } else if self?.buttonPicked?.tag == 1 {
                    self?.secondImage.image = newImage
                    self?.secondDocumentBase64 = strBase64
                }
            }
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
