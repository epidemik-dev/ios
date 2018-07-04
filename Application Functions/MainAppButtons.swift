//
//  MainAppButtons.swift
//  EpidemikUITests
//
//  Created by Ryan Bradford on 5/7/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import XCTest

extension XCUIApplication {

	// Presses the done button to dismiss the sickness view
	func pressDone() {
		self.otherElements["MainHolder"].otherElements["SicknessView"].buttons["DoneButton"].tap()
	}
	
	// Presses the button to show the settings view
	func pressSettings() {
		self.otherElements["MainHolder"].buttons["SettingsButton"].tap()
	}
	
	// Presses the log out button in the settings view
	func pressLogOut() {
		self.otherElements["MainHolder"].otherElements["SettingsView"].buttons["LogOutButton"].tap()
	}
	
	// Presses the button to say the user is sick
	func pressSick() {
		self.otherElements["MainHolder"].buttons["SickButton"].tap()
	}
	
	// Presses the submit button on the sickness page
	func submitSick() {
		self.otherElements["MainHolder"].otherElements["SicknessView"].otherElements["DiseaseNameScreen"].buttons["SubmitButton"].tap()
	}
	
	// Presses the done button on the sickness page
	func doneSick() {
		self.otherElements["MainHolder"].otherElements["DiseaseQuestionair"].buttons["DoneButton"].tap()
	}
	
	// Presses the button to say the user is healthy
	func pressHealthy() {
		self.otherElements["MainHolder"].buttons["HealthyButton"].tap()
	}
	
	// Says if the screen shows the sick button
	func doesShowSickButton() -> Bool {
		return self.otherElements["MainHolder"].buttons["SickButton"].frame.origin.x >= 0
	}
	
	// Says if the screen shows the healthy button
	func doesShowHealthyButton() -> Bool {
		return self.otherElements["MainHolder"].buttons["HealthyButton"].frame.origin.x >= 0
	}
	
}
