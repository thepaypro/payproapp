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
    var documentType:String = "Driving license"
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
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = PayProColors.background
        
        if documentType == "Driving license" {
            self.titleLabel.text = "TAKE A PHOTO OF FRONT DRIVING CARD"
            self.labelFirstPhoto.text = "Press to take a photo with front view"
            self.labelSecondPhoto.text = "Press to take a photo with back view"
            
        } else if documentType == "National ID Card" {
            self.titleLabel.text = "TAKE A PHOTO OF FRON NATIONAL CARD"
            self.labelFirstPhoto.text = "Press to take a photo with front view"
            self.labelSecondPhoto.text = "Press to take a photo with back view"
            
        } else if documentType == "Passport" {
            self.secondPhotoView.isHidden = true
            self.titleLabel.text = "TAKE A PHOTO OF PASSPORT"
            self.labelFirstPhoto.text = "Press to take a photo"
        }
        
        let next = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(callEndpoint))
        
        self.navigationItem.setRightBarButtonItems([next], animated: true)
        
        print(self.firstImage.frame.size.width)
        print(self.firstImage.frame.size.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callEndpoint()
    {
        let user = User.currentUser()
        
        let agreement: Int = Int((user?.accountType)!.rawValue)
        let forename: String = (user?.forename)!
        let lastname: String = (user?.lastname)!
        let birthDate: String = (user?.dob)!
        let documentType: String = (user?.documentType)!
        let street: String = (user?.street)!
        let buildingNumber: String = (user?.buildingNumber)!
        let postcode: String = (user?.postCode)!
        let city: String = (user?.city)!
//        let country: String = (user?.country)!
        let country: Int = 239
        let documentPicture1 = self.firstDocumentBase64
        let documentPicture2 = self.secondDocumentBase64
        
        User.accountCreate(
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
            documentFront: documentPicture1!,
            documentBack: documentPicture2!,
            completion: {successAccountCreate in
                if successAccountCreate {
                    print("create account success")
                    
                    let userDictionary = [
                        "id": User.currentUser()?.identifier,
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
                        "country": country
                    ] as [String : Any]
                    
                    let updateUser = User.manage(userDictionary: userDictionary as NSDictionary)
                    if updateUser != nil {
                        print("update user correctly")
                        self.navigationController?.popToRootViewController(animated: false)
//                        self.tabBarController?.selectedIndex = 3
                    } else {
                        print("update user error")
                    }
                } else {
                    print("create account problems")
                }
            }
        )
    }
    
    func openCamera()
    {
        let cameraViewController = CameraViewController(croppingEnabled: true, allowsLibraryAccess: true) { [weak self] image, asset in
            
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
