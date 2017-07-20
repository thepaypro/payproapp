//
//  PPDocumentPhotoViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet on 18/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

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
        let forename: String = (user?.forename)!
        let lastname: String = (user?.lastname)!
        let birthDate: String = (user?.dob)!
        let documentType: String = (user?.documentType)!
        let street: String = (user?.street)!
        let buildingNumber: String = (user?.buildingNumber)!
        let postcode: String = (user?.postCode)!
        let city: String = (user?.city)!
        let country: String = (user?.country)!
        let documentPicture1 = documentFront
        let documentPicture2 = documentBack
        
        User.accountCreate(documentFront: self.firstDocumentBase64, documentBack: self.secondDocumentBase64, completion: {successAccountCreate in
            if successAccountCreate {
                print("create account success")
            } else {
                print("create account problems")
            }
        })
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

