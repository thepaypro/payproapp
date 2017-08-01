//
//  PPCardAddressViewController.swift
//  thepayproapp
//
//  Created by Enric Giribet Usó on 1/8/17.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
//

import UIKit

class PPCardAddressViewController: UIViewController
{
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var buildingNumberLabel: UILabel!
    @IBOutlet weak var postCodeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let nextButton = UIBarButtonItem(title: "Confirm", style: .done, target: self, action: #selector(callEndPoint))
        
        self.navigationItem.rightBarButtonItem = nextButton
        
        let addressBorderTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let addressLayerTop = CAShapeLayer()
        addressLayerTop.path = addressBorderTop.cgPath
        addressLayerTop.fillColor = PayProColors.line.cgColor
        self.addressView.layer.addSublayer(addressLayerTop)
        
        let addressBorderBottom = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.4))
        let addressLayerBottom = CAShapeLayer()
        addressLayerBottom.path = addressBorderBottom.cgPath
        addressLayerBottom.fillColor = PayProColors.line.cgColor
        self.addressView.layer.addSublayer(addressLayerBottom)
        
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupView()
        print("aaa")
    }
    
    func setupView()
    {
        let user = User.currentUser()
        
        self.streetLabel.text = user?.street
        self.buildingNumberLabel.text = user?.buildingNumber
        self.postCodeLabel.text = user?.postCode
        self.cityLabel.text = user?.city
        self.countryLabel.text = user?.countryName
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callEndPoint()
    {
        CardConnection(completion: {cardRequestResponse in
            if cardRequestResponse["status"] as! Bool == true {
                self.dismissNavBarActivity()
                self.navigationController?.popToRootViewController(animated: false)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showAddressFormVC"
        {
            let formVC = segue.destination as! PPCardSecondFormViewController
            formVC.orderingCard = true
        }
    }
    
}
