//
//  SicknessSubmission.swift
//  EpidemikUITests
//
//  Created by Ryan Bradford on 6/25/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import XCTest

class SicknessSubmission: XCTestCase {

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
		app.launchArguments.append("--login")

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSubmitSick() {
		app.launch()
		XCTAssertFalse(app.isDisplayLogin())
		sleep(1)
		XCTAssertTrue(app.doesShowSickButton())
		app.pressSick()
		app.submitSick()
		app.doneSick()
		XCTAssertTrue(app.doesShowHealthyButton())
		
		app.launchArguments.remove(at: 2)
		app.launchArguments.remove(at: 1)

		app.launch()
		sleep(1)
		XCTAssertTrue(app.doesShowHealthyButton())
		
		submitHealthy()
	}
	
	func submitHealthy() {
		XCTAssertTrue(app.doesShowHealthyButton())
		
		app.pressHealthy()
		sleep(2)
		
		app.launch()
		
		sleep(1)
		
		XCTAssertTrue(app.doesShowSickButton())
	}

}
