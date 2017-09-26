//
//  PPScanQRViewController.swift
//  thepayproapp
//
//  Created by Roger Baiget on 20/9/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit
import AVFoundation

class PPScanQRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var sendMoney = SendMoney()
    var QRAlreadyDetected: Bool = false
    
    override func viewDidLoad() {
        
/*
        if sendMoney.bitcoinURISaveData(bitcoinURIString: "bitcoin:175tWpb8K1S7NmH4Zx6rewF9WQrcZv245W?amount=50&label=Luke-Jr&message=Donation%20for%20project%20xyz"){
            print("ValidBitcoinURI")
            print(sendMoney.getAccountNumber())
            print(sendMoney.getLabel())
            print(sendMoney.getAmount())
            print(sendMoney.getMessage())
             self.performSegue(withIdentifier: "sendBitcoinsSegue", sender: self)
        }else{
            print("InvalidBitcoinUri")
        }

*/
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        let input: AnyObject! = try? AVCaptureDeviceInput.init(device: captureDevice!)
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession?.startRunning()
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubview(toFront: qrCodeFrameView!)
    }
    override func viewWillAppear(_ animated: Bool) {
        QRAlreadyDetected = false
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode{
            // If the found metadata is equal to the QR code metadataset the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil && !QRAlreadyDetected{
                if sendMoney.bitcoinURISaveData(bitcoinURIString: metadataObj.stringValue){
                     print("ValidBitcoinURI")
                     print(sendMoney.getAccountNumber())
                     print(sendMoney.getLabel())
                     print(sendMoney.getAmount())
                     print(sendMoney.getMessage())
                     QRAlreadyDetected = true
             
                    self.sendMoney.setCurrencyType(currencyTypeValue: 1)
                    
                    //EndPoint de checkear si es usuario pay pro
                    self.sendMoney.setOperationType(operationTypeValue: 1)
                    //self.sendMoney.setOperationType(operationTypeValue: 0)
                    
                    self.performSegue(withIdentifier: "sendBitcoinsSegue", sender: self)
                }else{
                    print("InvalidBitcoinUri")
                    //Bitcoin Uri no valida show alert
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendBitcoinsSegue" {
            let sendMoneyInAppVC : PPSendMoneyAmountViewController = segue.destination as! PPSendMoneyAmountViewController
            sendMoneyInAppVC.sendMoney = sendMoney
        }
    }
    
    
}
