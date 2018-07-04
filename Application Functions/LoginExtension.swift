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
	
	func isDisplayStage1() -> Bool {
		return otherElements["AddressCreator"].frame.origin.x >= 0
	}
	
	// Puts the given string into the username box
	func fillOutUsername(name: String) {
		fillOutLoginTextbox(id: "UsernameTextBox", text: name)
	}
	
	// Puts the given string into the password box
	func fillOutPassword(password: String) {
		let login = otherElements["LoginScreen"]
		
		let textField = login.children(matching: XCUIElement.ElementType.secureTextField)["PasswordTextBox"]
		
		textField.tap()
		textField.typeText(password)
	}
	
	// Puts the given string into the given box in the login screen
	func fillOutLoginTextbox(id: String, text: String) {
		let login = otherElements["LoginScreen"]
		
		let textField = login.children(matching: XCUIElement.ElementType.textField)[id]
		
		textField.tap()
		textField.typeText(text)
	}
	
	// Presses login/create account button on the login screen
	func pressLogin() {
		let login = otherElements["LoginScreen"]
		let loginButton = login.buttons["LoginButton"]
		loginButton.tap()
	}
	
	func loginTestUser() {
		self.fillOutUsername(name: "rya")
		self.fillOutPassword(password: "pass")
		self.fillOutUsername(name: "n")
		
		self.pressLogin()
	}
	
	func loginIsInFocus() -> Bool {
		let login = otherElements["LoginScreen"]
		return login.textFields["UsernameTextBox"].frame.origin.y > 0
	}
	
}
