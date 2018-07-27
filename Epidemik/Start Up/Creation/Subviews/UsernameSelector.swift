//
//  UsernamePasswordItem.swift
//  Epidemik
//
//  Created by Ryan Bradford on 7/26/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class UsernameSelector: CreateItem, UITextFieldDelegate {
	
	var slideDown: (() -> ())!
	var slideUp: (() -> ())!
	var warnUser: ((String) -> ())!
	var usernameTextBox: AccCreationTextBox!
	var passwordTextBox: AccCreationTextBox!
	
	init(frame: CGRect, slideUp: @escaping () -> (), slideDown: @escaping () -> (), warnUser: @escaping (String) -> ()) {
		super.init(frame: frame)
		self.title = "Enter your username, password"
		self.slideDown = slideDown
		self.slideUp = slideUp
		self.warnUser = warnUser
		initUsernameTextbox()
		initPasswordTextbox()
		warnUser("Invalid Password")
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initUsernameTextbox() {
		self.usernameTextBox = AccCreationTextBox(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50), toDisplay: FileRW.readImage(imageName: "username"))
		self.usernameTextBox.text = "username"
		self.usernameTextBox.accessibilityIdentifier = "username"
		self.usernameTextBox.clearsOnBeginEditing = true
		self.usernameTextBox.delegate = self
		self.addSubview(self.usernameTextBox)
	}
	
	func initPasswordTextbox() {
		self.passwordTextBox = AccCreationTextBox(frame: CGRect(x: 0, y: 100, width: self.frame.width, height: 50), toDisplay: FileRW.readImage(imageName: "password"))
		self.passwordTextBox.isSecureTextEntry = true
		self.passwordTextBox.text = "password"
		self.passwordTextBox.accessibilityIdentifier = "password"
		self.passwordTextBox.clearsOnBeginEditing = true
		self.passwordTextBox.delegate = self
		self.addSubview(self.passwordTextBox)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.slideDown()
		return false
	}
	
	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
		self.slideDown()
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		self.slideUp()
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		var totalText = textField.text! + string
		if(string == "") {
			if(totalText.count > 0) {
				totalText = String(totalText.dropLast())
			}
		}
		updateWarning(passwordOrUsername: textField.accessibilityIdentifier == "password", text: totalText)
		return true
	}
	
	func updateWarning(passwordOrUsername: Bool, text: String) {
		if(passwordOrUsername) {
			if(text.count < 6) {
				self.warnUser("Password Too Short")
				return
			} else if(text.lowercased() == "password") {
				self.warnUser("Invalid password")
				return
			}
		} else {
			if(text.contains(" ") || text.contains("\\")) {
				self.warnUser("Invalid username")
				return
			}
		}
		self.warnUser("")
	}
	
	override func getInfo() -> [String] {
		return [self.usernameTextBox.text!, self.passwordTextBox.text!]
	}
	
}

