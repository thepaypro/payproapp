//
//  PPShowQRCode.swift
//  thepayproapp
//
//  Created by Roger Baiget on 2/10/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPShowQRCode: UIViewController{
    
    @IBOutlet weak var QRCode: UIImageView!
    var dataToQR: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var qrcodeImage: CIImage!
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(dataToQR?.data(using: String.Encoding.isoLatin1, allowLossyConversion: false), forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrcodeImage = filter?.outputImage
        
        let scaleX = QRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = QRCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        QRCode.image = UIImage(ciImage: transformedImage)
        
        // Do any additional setup after loading the view.
    }
}
