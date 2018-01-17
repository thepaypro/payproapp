//
//  PayProAppTests.swift
//  PayProAppTests
//
//  Created by Enric Giribet on 15/1/18.
//  Copyright © 2018 The Pay Pro LTD. All rights reserved.
//

import XCTest
@testable import thepayproapp

class PayProAppTests: XCTestCase {
    var vcLogin: PPPasscodeViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: PPPasscodeViewController = storyboard.instantiateViewController(withIdentifier: "PPPasscodeViewController") as! PPPasscodeViewController
        vcLogin = vc
        _ = vcLogin.view // To call viewDidLoad
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUserCreate() {
        vcLogin.changePassword = false
        vcLogin.userUsername = "+34691487998"
        vcLogin.passcodeTF.text = "1234"
        
        vcLogin.nextTapped()
    }
}
