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
    @IBOutlet weak var firstPhotoView: UIView!
    @IBOutlet weak var secondPhotoView: UIView!
    @IBAction func firstButtonAction(_ sender: Any) {
        buttonPicked = sender as? UIButton
        openCamera()
    }
    @IBAction func secondButtonAction(_ sender: Any) {
        buttonPicked = sender as? UIButton
        openCamera()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print(self.viewContent.frame.size.width)
        
        self.view.backgroundColor = PayProColors.background
        
        if documentType == "Driving license" {
            self.titleLabel.text = "TAKE A PHOTO OF FRONT DRIVING CARD"
            
        } else if documentType == "National ID Card" {
            self.titleLabel.text = "TAKE A PHOTO OF FRON NATIONAL CARD"
            
        } else if documentType == "Passport" {
            self.titleLabel.text = "TAKE A PHOTO OF PASSPORT"
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    }
    
    private func shouldAutorotate() -> Bool {
        return true
    }
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            imagePicker.allowsEditing = false
            
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
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
        print(strBase64)
        
        buttonPicked?.setImage(UIImage(data: imageData as Data), for: .normal)
    }
}

