//
//  thepayproappTests.swift
//  thepayproappTests
//
//  Created by Manuel Ortega Cordovilla on 30/05/2017.
//  Copyright © 2017 The Pay Pro LTD. All rights reserved.
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
