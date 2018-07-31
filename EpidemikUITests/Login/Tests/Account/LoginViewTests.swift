//
//  LoginViewTests.swift
//  EpidemikTests
//
//  Created by Ryan Bradford on 5/12/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import XCTest

class LoginViewTests: XCTestCase {
	
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
	
	// Tests that no matter the shifting, the
	// Objects always stay in focus
	func testShiftUpDown() {
		app.launch()
		sleep(1)
		
		XCTAssert(app.isDisplayLogin())
		XCTAssert(app.loginIsInFocus())
		
		app.fillOutUsername(name: "user")
		XCTAssert(app.loginIsInFocus())
		
		app.fillOutPassword(password: "pass")
		XCTAssert(app.loginIsInFocus())
		
		app.fillOutPassword(password: "\n")
		XCTAssert(app.loginIsInFocus())
		
		app.fillOutPassword(password: "passs")
		XCTAssert(app.loginIsInFocus())

		app.fillOutUsername(name: "\n")
		XCTAssert(app.loginIsInFocus())
		
		app.fillOutUsername(name: "user")
		XCTAssert(app.loginIsInFocus())
		
		app.fillOutUsername(name: "\n")
		XCTAssert(app.loginIsInFocus())

	}
}
