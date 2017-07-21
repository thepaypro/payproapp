//
//  PPImagePickerController.swift
//  thepayproapp
//
//  Created by Enric Giribet Usó on 20/7/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPImagePickerController : UIImagePickerController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return .landscape
    }
    
    override var shouldAutorotate: Bool
    {
        return true
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation
    {
        return .landscapeRight
    }
}
