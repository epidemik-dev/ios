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

	// Presses the done button
	func pressDone() {
		self.buttons["done"].tap()
	}
	
	// Presses the exit button
	func pressExit() {
		self.buttons["exit"].tap()
	}
	
	// Presses the add to map button
	func pressAddToMap() {
		self.buttons["add_to_map"].tap()
	}
	
	// Presses the submit button
	func pressSubmit() {
		self.buttons["submit"].tap()
	}
	
	// Presses the continue button
	func pressContinue() {
		self.buttons["continue"].tap()
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
		self.buttons["SubmitButton"].tap()
	}
	
	// Presses the button to say the user is healthy
	func pressHealthy() {
		self.buttons["HealthyButton"].tap()
	}
	
	// Presses the diagnosis button to enterer the diagnosis process
	func pressDiagnose() {
		self.buttons["diagnose"].tap()
	}
	
	// Presses the button to agree to the diagnosis terms
	func pressAgree() {
		self.buttons["agree"].tap()
	}
	
	// Presses the head to select symboms
	func pressHead() {
		self.buttons["head"].tap()
	}
	
	// Presses this symptom selector button
	func selectSymptom(symID: Int) {
		self.buttons["symptom" + String(symID)].tap()
	}
	
	// Says if the app is showing this diagnosis item
	func hasDiagnosedWith(diseaseName: String) -> Bool {
		return self.buttons[diseaseName].exists
	}
	
	// Says if the screen shows the sick button
	func doesShowSickButton() -> Bool {
		return self.buttons["SickButton"].exists && self.buttons["SickButton"].frame.origin.x >= 0
	}
	
	// Says if the screen shows the healthy button
	func doesShowHealthyButton() -> Bool {
		return self.buttons["HealthyButton"].exists && self.buttons["HealthyButton"].frame.origin.x >= 0
	}
	
	// Says if the app could diagnose the user
	func couldDiagnose() -> Bool {
		return !self.textViews["noinfo"].exists
	}
	
	// Returns the status indicator on the sick view
	func getStatusIndicator() -> String {
		return self.staticTexts["status_view"].label
	}
	
}
