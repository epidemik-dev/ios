//
//  LogInProcessTests.swift
//  EpidemikUITests
//
//  Created by Ryan Bradford on 5/3/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import XCTest

class LogInProcessTest: XCTestCase {
	
	var app: XCUIApplication!
	
	override func setUp() {
		super.setUp()
		
		// Put setup code here. This method is called before the invocation of each test method in the class.
		
		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false
		
		app = XCUIApplication()
		app.launchArguments.append("--uitesting")
		app.launchArguments.append("--reset")
		app.launchArguments.append("--reset-data")
		// UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
		
		// In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	// Tests that the login fails given bad info
	func testLoginFail() {
		app.launch()
		
		XCTAssertTrue(app.isDisplayLogin())
		
		app.fillOutUsername(name: "use")
		app.fillOutPassword(password: "password1")
		app.fillOutUsername(name: "jasdh")
		
		app.pressLogin()
		
		sleep(2)
		
		XCTAssertTrue(app.isDisplayLogin())
	}
	
}
