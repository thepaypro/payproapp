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
    var documentType:String = ""
    var buttonPicked:UIButton?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("documentType: \(documentType)")
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let viewTitle = UIView()
        viewTitle.frame = CGRect(x: 0, y:0, width: self.view.frame.size.width, height: 43)
        
        let titleLabel = UILabel()
        //        Driving Licence", "Passport", "National ID Card"
        if documentType == "Driving license" {
            titleLabel.text = "TAKE A PHOTO OF FRONT DRIVING CARD"
            
        } else if documentType == "National ID Card" {
            titleLabel.text = "TAKE A PHOTO OF FRON NATIONAL CARD"
            
        } else if documentType == "Passport" {
            titleLabel.text = "TAKE A PHOTO OF PASSPORT"
        }
        
        titleLabel.tintColor = PayProColors.title
        
        viewTitle.addSubview(titleLabel)
        
        self.view.insertSubview(viewTitle, at: 0)
        
        
        let viewContentPhoto = UIView()
        viewContentPhoto.frame = CGRect(x: 0, y:43, width: self.view.frame.size.width, height: viewContentPhoto.frame.size.height - 43)
        viewContentPhoto.backgroundColor = UIColor.white
        
        let viewTakePhoto = UIView()
        viewTakePhoto.frame = CGRect(x: 15, y:15, width: self.view.frame.size.width - 30, height: viewContentPhoto.frame.size.height / 2 - 30)
        
        let dashedBorder = CAShapeLayer()
        dashedBorder.strokeColor = UIColor.black.cgColor
        dashedBorder.lineDashPattern = [2, 2]
        dashedBorder.frame = viewTakePhoto.bounds
        dashedBorder.path = UIBezierPath(rect: viewTakePhoto.bounds).cgPath
        dashedBorder.fillColor = UIColor.white.cgColor
        viewTakePhoto.layer.addSublayer(dashedBorder)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: viewTakePhoto.frame.size.width, height: viewTakePhoto.frame.size.height))
        button.backgroundColor = UIColor.clear
        button.setTitle("Press to take a photo", for: .normal)
        button.setTitleColor(PayProColors.title, for: .normal)
        button.tag = 0
        button.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        
        let xcamera = viewTakePhoto.frame.size.width / 2 - 34
        let ycamera = viewTakePhoto.frame.size.height / 2 - 70
        
        let cameraIcon = UIImageView(frame: CGRect(x: xcamera, y: ycamera, width: 69, height: 69))
        cameraIcon.contentMode = .scaleAspectFill
        cameraIcon.image = UIImage(named: "camera")
        button.addSubview(cameraIcon)
        
        viewTakePhoto.addSubview(button)
        
        viewContentPhoto.addSubview(viewTakePhoto)
        
        
        //Second Photo
        let viewTakeSecondPhoto = UIView()
        viewTakeSecondPhoto.frame = CGRect(x: 15, y: viewContentPhoto.frame.size.height / 2 + 15, width: self.view.frame.size.width - 30, height: viewContentPhoto.frame.size.height / 2 - 30)
        
        let dashedBorderSecond = CAShapeLayer()
        dashedBorderSecond.strokeColor = UIColor.black.cgColor
        dashedBorderSecond.lineDashPattern = [2, 2]
        dashedBorderSecond.frame = viewTakeSecondPhoto.bounds
        dashedBorderSecond.path = UIBezierPath(rect: viewTakeSecondPhoto.bounds).cgPath
        dashedBorderSecond.fillColor = UIColor.white.cgColor
        viewTakeSecondPhoto.layer.addSublayer(dashedBorderSecond)
        
        let buttonSecond = UIButton(frame: CGRect(x: 0, y: 0, width: viewTakeSecondPhoto.frame.size.width, height: viewTakeSecondPhoto.frame.size.height))
        buttonSecond.backgroundColor = UIColor.clear
        buttonSecond.setTitle("Press to take a photo", for: .normal)
        buttonSecond.setTitleColor(PayProColors.title, for: .normal)
        buttonSecond.tag = 1
        buttonSecond.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        
        let xcameraSecond = viewTakeSecondPhoto.frame.size.width / 2 - 34
        let ycameraSecond = viewTakeSecondPhoto.frame.size.height / 2 - 70
        
        let cameraIconSecond = UIImageView(frame: CGRect(x: xcameraSecond, y: ycameraSecond, width: 69, height: 69))
        cameraIconSecond.contentMode = .scaleAspectFill
        cameraIconSecond.image = UIImage(named: "camera")
        buttonSecond.addSubview(cameraIconSecond)
        
        viewTakeSecondPhoto.addSubview(buttonSecond)
        
        viewContentPhoto.addSubview(viewTakeSecondPhoto)
        
        self.view.addSubview(viewContentPhoto)
    }
    
    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    }
    
    private func shouldAutorotate() -> Bool {
        return true
    }
    
    func openCamera(_ sender: UIButton)
    {
        buttonPicked = sender
        
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
        
        buttonPicked?.setImage(UIImage(data: imageData as Data), for: .normal)
    }
}

