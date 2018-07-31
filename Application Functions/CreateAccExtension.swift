//
//  CreateAccExtension.swift
//  EpidemikUITests
//
//  Created by Ryan Bradford on 5/4/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import XCTest

extension XCUIApplication {
	
	// Puts the given string into the address box
	func fillOutAddress(name: String) {
		fillOutTextbox(id: "AddressTextBox", text: name)
	}
	
	// Puts the given string into the city box
	func fillOutCity(name: String) {
		fillOutTextbox(id: "CityTextBox", text: name)
	}
	
	// Puts the given string into the state box
	func fillOutState(name: String) {
		fillOutTextbox(id: "StateTextBox", text: name)
	}
	
	// Sets the gender option for this user
	func setMaleOrFemaleOrOther(gender: String) {
		if(gender == "Male") {
			self.buttons["MaleButton"].tap()
		} else if(gender == "Female") {
			self.buttons["FemaleButton"].tap()
		} else {
			self.buttons["OtherButton"].tap()
		}
	}
	
	// Changes the login screen to the create acc screen
	func turnToCreateAcc() {
		self.buttons["CreateAccButton"].tap()
	}
	
	// Goes to the next create screen
	func nextCreateScreen() {
		self.buttons["next"].tap()
	}
	
	// Puts the given string into the given box in the login screen
	func fillOutTextbox(id: String, text: String) {
		let textField = self.textFields[id]
		
		textField.tap()
		textField.typeText(text)
	}
	
	func getPasswordWarningVal() -> String {
		return self.textViews["Warning"].value as! String
	}
	
	// Puts the given string into the username box
	func createUsername(name: String) {
		let textField = self.textFields["usernameCreate"]
		
		textField.tap()
		textField.typeText(name)
	}
	
	// Puts the given string into the password box
	func createPassword(password: String) {
		let textField = self.secureTextFields["passwordCreate"]
		
		textField.tap()
		textField.typeText(password)
	}
	
}
