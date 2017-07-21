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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callEndpoint()
    {
//        let user = User.currentUser()
//        
//        let forename: String = (user?.forename)!
//        let lastname: String = (user?.lastname)!
//        let birthDate: String = (user?.dob)!
//        let documentType: String = (user?.documentType)!
//        let street: String = (user?.street)!
//        let buildingNumber: String = (user?.buildingNumber)!
//        let postcode: String = (user?.postCode)!
//        let city: String = (user?.city)!
//        let country: String = (user?.country)!
//        let documentPicture1 = self.firstDocumentBase64
//        let documentPicture2 = self.secondDocumentBase64
//        
//        User.accountCreate(documentFront: self.firstDocumentBase64, documentBack: self.secondDocumentBase64, completion: {successAccountCreate in
//            if successAccountCreate {
//                print("create account success")
//            } else {
//                print("create account problems")
//            }
//        })
    }
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = PPImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            imagePicker.allowsEditing = false
            
            let rectangleTopLeftTop = UIView()
            rectangleTopLeftTop.frame = CGRect(x: 50, y:50, width: 100, height: 3)
            rectangleTopLeftTop.backgroundColor = PayProColors.lightGreen
            
            let rectangleTopLeftLeft = UIView()
            rectangleTopLeftLeft.frame = CGRect(x: 50, y:50, width: 3, height: 25)
            rectangleTopLeftLeft.backgroundColor = PayProColors.lightGreen
            
            let rectangleTopRightTop = UIView()
            rectangleTopRightTop.frame = CGRect(x: imagePicker.view.frame.size.height - 330, y:50, width: 100, height: 3)
            rectangleTopRightTop.backgroundColor = PayProColors.lightGreen
            
            let rectangleTopRightRight = UIView()
            rectangleTopRightRight.frame = CGRect(x: imagePicker.view.frame.size.height - 230, y:50, width: 3, height: 25)
            rectangleTopRightRight.backgroundColor = PayProColors.lightGreen
            
            let rectangleBottomLeftBottom = UIView()
            rectangleBottomLeftBottom.frame = CGRect(x: 50, y:imagePicker.view.frame.size.width - 58, width: 100, height: 3)
            rectangleBottomLeftBottom.backgroundColor = PayProColors.lightGreen
            
            let rectangleBottomLeftLeft = UIView()
            rectangleBottomLeftLeft.frame = CGRect(x: 50, y:imagePicker.view.frame.size.width - 83, width: 3, height: 25)
            rectangleBottomLeftLeft.backgroundColor = PayProColors.lightGreen
            
            let rectangleBottomRightBottom = UIView()
            rectangleBottomRightBottom.frame = CGRect(x: imagePicker.view.frame.size.height - 330, y:imagePicker.view.frame.size.width - 58, width: 100, height: 3)
            rectangleBottomRightBottom.backgroundColor = PayProColors.lightGreen
            
            let rectangleBottomRightRight = UIView()
            rectangleBottomRightRight.frame = CGRect(x: imagePicker.view.frame.size.height - 230, y:imagePicker.view.frame.size.width - 80, width: 3, height: 25)
            rectangleBottomRightRight.backgroundColor = PayProColors.lightGreen
            
            let labelBottomCenter = UILabel()
            labelBottomCenter.text = "Take a photo bla bla bla"
            labelBottomCenter.textAlignment = .center
            labelBottomCenter.textColor = UIColor.white
            labelBottomCenter.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
            labelBottomCenter.frame = CGRect(x: 0, y: imagePicker.view.frame.size.width - 50, width: imagePicker.view.frame.size.height - 180, height: 20)
            
            let rectangleFull = UIView()
            rectangleFull.frame = CGRect(x: 50, y:0, width: imagePicker.view.frame.size.height - 180, height: imagePicker.view.frame.width)
            rectangleFull.backgroundColor = UIColor.clear
            
            rectangleFull.addSubview(rectangleTopLeftTop)
            rectangleFull.addSubview(rectangleTopLeftLeft)
            rectangleFull.addSubview(rectangleTopRightTop)
            rectangleFull.addSubview(rectangleTopRightRight)
            rectangleFull.addSubview(rectangleBottomLeftBottom)
            rectangleFull.addSubview(rectangleBottomLeftLeft)
            rectangleFull.addSubview(rectangleBottomRightBottom)
            rectangleFull.addSubview(rectangleBottomRightRight)
            rectangleFull.addSubview(labelBottomCenter)
            
            imagePicker.cameraOverlayView = rectangleFull
            
//            let value = UIInterfaceOrientation.landscapeLeft.rawValue
//            UIDevice.current.setValue(value, forKey: "orientation")
            
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("problems with open camera")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            prepareImageForSaving(image: editedImage)
            
        } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            prepareImageForSaving(image: pickedImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func prepareImageForSaving(image:UIImage)
    {
        guard let imageData  = UIImageJPEGRepresentation(image, 1.0) else {
            // handle failed conversion
            print("jpg error")
            return
        }
        
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
//        print(strBase64)
        
        let imageview = UIImageView()
        imageview.image = UIImage(data: imageData as Data)
        
        if buttonPicked?.tag == 0 {
            self.firstImage.image = UIImage(data: imageData as Data)
            self.firstDocumentBase64 = strBase64
        } else if buttonPicked?.tag == 1 {
            self.secondImage.image = UIImage(data: imageData as Data)
            self.secondDocumentBase64 = strBase64
        }
//        buttonPicked?.setImage(UIImage(data: imageData as Data), for: .normal)
    }
}

