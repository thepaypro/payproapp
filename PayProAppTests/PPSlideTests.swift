//
//  PPSlideTest.swift
//  PayProAppTests
//
//  Created by Enric Giribet on 17/1/18.
//  Copyright © 2018 The Pay Pro LTD. All rights reserved.
//

import XCTest
@testable import thepayproapp

class PPSlideTests: XCTestCase {
//    var vcSlide:PPSliderViewController
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: PPSliderViewController = storyboard.instantiateViewController(withIdentifier: "PPSliderViewController") as! PPSliderViewController
        vcSlide = vc
        _ = vcSlide.view // To call viewDidLoad
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        vcSlide.continueButton.sendActions(for: .touchUpInside)
    }
    
}
