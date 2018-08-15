//
//  DiagnosisTest.swift
//  EpidemikUITests
//
//  Created by Ryan Bradford on 8/1/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import XCTest

class DiagnosisTest: XCTestCase {

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
	
	func testDiagnosisDontAddToMap() {
		app.launch()
		XCTAssertFalse(app.isDisplayLogin())
		sleep(5)
		if(app.doesShowHealthyButton()) {
			app.pressHealthy()
			sleep(1)
		}
		XCTAssertTrue(app.doesShowSickButton())
		app.pressDiagnose()
		app.pressAgree()
		app.pressHead()
		app.selectSymptom(symID: 1)
		app.pressContinue()
		app.pressSubmit()
		sleep(1)
		XCTAssertTrue(app.couldDiagnose())
		XCTAssertTrue(app.hasDiagnosedWith(diseaseName: "Common Cold"))
		app.pressExit()
		XCTAssertTrue(app.doesShowSickButton())
		XCTAssertTrue(app.getStatusIndicator().contains("Healthy"))
		app.launch()
		sleep(5)
		XCTAssertTrue(app.doesShowSickButton())
	}
	
	func testDiagnosisDoAddToMap() {
		app.launch()
		XCTAssertFalse(app.isDisplayLogin())
		sleep(5)
		if(app.doesShowHealthyButton()) {
			app.pressHealthy()
			sleep(1)
		}
		XCTAssertTrue(app.doesShowSickButton())
		app.pressDiagnose()
		app.pressAgree()
		app.pressHead()
		app.selectSymptom(symID: 1)
		app.pressContinue()
		app.pressSubmit()
		sleep(1)
		XCTAssertTrue(app.couldDiagnose())
		XCTAssertTrue(app.hasDiagnosedWith(diseaseName: "Common Cold"))
		app.pressAddToMap()
		XCTAssertTrue(app.doesShowHealthyButton())
		XCTAssertTrue(app.getStatusIndicator().contains("Sick"))
		app.launch()
		sleep(5)
		XCTAssertTrue(app.doesShowHealthyButton())
	}
	
	
	func testCannotDiagnose() {
		app.launch()
		XCTAssertFalse(app.isDisplayLogin())
		sleep(3)
		if(app.doesShowHealthyButton()) {
			app.pressHealthy()
			sleep(1)
		}
		XCTAssertTrue(app.doesShowSickButton())
		app.pressDiagnose()
		app.pressAgree()
		app.pressSubmit()
		sleep(1)
		XCTAssertFalse(app.couldDiagnose())
	}


}
