//
//  LogOutTest.swift
//  EpidemikUITests
//
//  Created by Ryan Bradford on 5/5/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import XCTest

class LogOutTest: XCTestCase {
	
	var app: XCUIApplication!
	
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
		
		app = XCUIApplication()
		app.launchArguments += ["--login", "--reset-data"]
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogOut() {
		app.launch()
		sleep(1)
		app.pressDone()
		
		//Press settings
		app.pressSettings()
		
		// Press Log Out
		app.pressLogOut()
		
		// Test that login shows
		XCTAssert(app.isDisplayLogin())
		
		app.launchArguments.remove(at: 0)
		// Relaunch app
		app.launch()
		sleep(1)
		
		// Test that login shows
		XCTAssert(app.isDisplayLogin())
    }
    
}
