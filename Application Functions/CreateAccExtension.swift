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
		fillOutAddressTextbox(id: "AddressTextBox", text: name)
	}
	
	// Puts the given string into the city box
	func fillOutCity(name: String) {
		fillOutAddressTextbox(id: "CityTextBox", text: name)
	}
	
	// Puts the given string into the state box
	func fillOutState(name: String) {
		fillOutAddressTextbox(id: "StateTextBox", text: name)
	}
	
	// Sets the gender option for this user
	func setMaleOrFemaleOrOther(gender: String) {
		let login = otherElements["LoginScreen"]
		let genderSelector = login.otherElements["GenderSelector"]
		if(gender == "Male") {
			genderSelector.buttons["MaleButton"].tap()
		} else if(gender == "Female") {
			genderSelector.buttons["FemaleButton"].tap()
		} else {
			genderSelector.buttons["OtherButton"].tap()
		}
	}
	
	// Sets the date of birth of this user
	func setDOB(month: String, day: String, year: String) {
		let login = otherElements["LoginScreen"]
		login.datePickers["DOBPicker"].pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: month)
		login.datePickers["DOBPicker"].pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: day)
		login.datePickers["DOBPicker"].pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: year)
	}
	
	// Changes the login screen to the create acc screen
	func turnToCreateAcc() {
		let login = otherElements["LoginScreen"]
		login.buttons["CreateAccButton"].tap()
	}
	
	// Puts the given string into the given box in the login screen
	func fillOutAddressTextbox(id: String, text: String) {
		let login = otherElements["LoginScreen"]
		let createAcc = login.otherElements["AddressCreator"]
		
		let textField = createAcc.children(matching: XCUIElement.ElementType.textField)[id]
		
		textField.tap()
		textField.typeText(text)
	}
	
	func getPasswordWarningVal() -> String {
		let login = otherElements["LoginScreen"]
		return login.textViews["PasswordWarning"].value as! String
	}
	
}
