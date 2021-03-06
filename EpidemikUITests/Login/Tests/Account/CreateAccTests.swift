//
//  LogInProcessTests.swift
//  EpidemikUITests
//
//  Created by Ryan Bradford on 5/3/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import XCTest

class CreateAccTest: XCTestCase {
	
	var app: XCUIApplication!
	
	var username = String(arc4random())
	
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

	// Tests that you can create an account and that it will be sent to the server
	func testCreateAccountSucceed() {
		// Test that the create account function can advance
		app.launch()
		
		app.turnToCreateAcc()
		app.nextCreateScreen()
		app.nextCreateScreen()
		app.nextCreateScreen()
		app.nextCreateScreen()

		app.fillOutAddress(name: "1 Main St")
		app.fillOutCity(name: "New York")
		app.fillOutState(name: "NY")
		
		app.nextCreateScreen()
		sleep(1)
		
		app.createPassword(password: "password")
		XCTAssertEqual(app.getPasswordWarningVal(), "Invalid password")
		app.createPassword(password: "d")
		XCTAssertEqual(app.getPasswordWarningVal(), "")
		app.createUsername(name: username)
		XCTAssertTrue(app.isDisplayLogin())

		app.nextCreateScreen()

		sleep(2)
		
		XCTAssertFalse(app.isDisplayLogin())
		
		// Test that after you log in it will go straight to the
		// main app
		app.launchArguments.remove(at: 2) // Don't reset the data
		app.launchArguments.remove(at: 1) // Don't deletes the files from the disk
		
		app.launch()
		
		sleep(1)
		
		XCTAssertFalse(app.isDisplayLogin())
		
		// Test that you can log into the same account
		app.launchArguments.append("--reset") // Do clear the files
		app.launch()
		
		XCTAssertTrue(app.isDisplayLogin())
		
		app.fillOutUsername(name: username)
		app.fillOutPassword(password: "passwordd")
		
		app.pressLogin()
		
		sleep(2)
		
		XCTAssertFalse(app.isDisplayLogin())
		
	}
	
	// Test that you cannot create an account with a short
	// password
	func testCreateAccountFailShortPassword() {
		app.launch()
		
		app.turnToCreateAcc()
		app.nextCreateScreen()
		app.nextCreateScreen()
		app.nextCreateScreen()
		app.nextCreateScreen()
		
		app.fillOutAddress(name: "1 Main St")
		app.fillOutCity(name: "New York")
		app.fillOutState(name: "NY")
		
		app.nextCreateScreen()
		sleep(1)
		
		app.createPassword(password: "testt")
		app.createUsername(name: "ryan1")
		
		XCTAssertEqual(app.getPasswordWarningVal(), "Password Too Short")
		
		app.nextCreateScreen()
		
		sleep(2)
		XCTAssertTrue(app.isDisplayLogin())
	}
	
	// Test that you cannot create an account with the password = password
	func testCreateAccountFailPasswordPassword() {
		app.launch()
		app.turnToCreateAcc()
		app.nextCreateScreen()
		app.nextCreateScreen()
		app.nextCreateScreen()
		app.nextCreateScreen()
		
		app.fillOutAddress(name: "1 Main St")
		app.fillOutCity(name: "New York")
		app.fillOutState(name: "NY")
		
		app.nextCreateScreen()
		sleep(1)
		
		app.createPassword(password: "password")
		app.createUsername(name: "ryan1")
		
		XCTAssertEqual(app.getPasswordWarningVal(), "Invalid password")
		
		app.nextCreateScreen()
		
		sleep(1)
		XCTAssertTrue(app.isDisplayLogin())
	}
	
	// Test that you cannot create an account with an invalid address
	func testCreateAccountFailBadAddress() {
		app.launch()
		app.turnToCreateAcc()
		app.nextCreateScreen()
		app.nextCreateScreen()
		app.nextCreateScreen()
		app.nextCreateScreen()
		
		app.fillOutAddress(name: "BadAddress")
		app.fillOutCity(name: "BadAddress")
		app.fillOutState(name: "BadAddress")
		app.nextCreateScreen()
		
		sleep(1)
		XCTAssertTrue(app.isDisplayStageAddress())
	}
	
	// Test that you cannot create an account as an already existing user
	func testCreateAccountFailExistingUser() {
		app.launch()
		app.turnToCreateAcc()
		app.nextCreateScreen()
		app.nextCreateScreen()
		app.nextCreateScreen()
		app.nextCreateScreen()
		
		app.fillOutAddress(name: "1 Main St")
		app.fillOutCity(name: "New York")
		app.fillOutState(name: "NY")
		app.nextCreateScreen()
		sleep(1)
		
		app.createPassword(password: "passwordd")
		app.createUsername(name: "ryan-bradford")
		app.nextCreateScreen()
						
		sleep(2)
		XCTAssertTrue(app.isDisplayLogin())
	}
	
}
