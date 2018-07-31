//
//  LogInProcessTests.swift
//  EpidemikUITests
//
//  Created by Ryan Bradford on 5/3/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import XCTest

class BadVersionTests: XCTestCase {
	
	var app: XCUIApplication!
	
	override func setUp() {
		super.setUp()
		
		// Put setup code here. This method is called before the invocation of each test method in the class.
		
		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false
		
		
		app = XCUIApplication()
		app.launchArguments.append("--login")
		app.launchArguments.append("--reset")
		app.launchArguments.append("--reset-data")
		app.launchArguments.append("--bad-version")
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	// Tests that when the app launches with a bad version
	// It shows the bad version screen
	func testBadVersion() {
		app.launch()
		sleep(1)
		XCTAssert(app.otherElements["BadScreen"].exists)
	}
	
}
