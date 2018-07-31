//
//  LoginExtension.swift
//  EpidemikUITests
//
//  Created by Ryan Bradford on 5/4/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import XCTest

extension XCUIApplication {
	
	// Tests if the view controller is showing the login screen
	func isDisplayLogin() -> Bool {
		return otherElements["LoginScreen"].exists
	}
	
	func isDisplayStageAddress() -> Bool {
		return otherElements["AddressCreator"].frame.origin.x >= 0
	}
	
	// Puts the given string into the username box
	func fillOutUsername(name: String) {
		let textField = self.textFields["username"]
		
		textField.tap()
		textField.typeText(name)
		
	}
	
	// Puts the given string into the password box
	func fillOutPassword(password: String) {
		let textField = self.secureTextFields["password"]
		
		textField.tap()
		textField.typeText(password)
	}
	
	// Presses login/create account button on the login screen
	func pressLogin() {
		let loginButton = self.buttons["login"]
		loginButton.tap()
	}
	
	func loginIsInFocus() -> Bool {
		return self.textFields["username"].frame.origin.y > 0
	}
	
}
