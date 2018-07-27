//
//  Login.swift
//  Epidemik
//
//  Created by Ryan Bradford on 7/25/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class LoginScreen: UIView, UITextFieldDelegate {
	
	var slideDown: (() -> ())!
	var slideUp: (() -> ())!
	var slideAway: (() -> ())!
	var turnToCreate: (() -> ())!
	var usernameTextBox: AccCreationTextBox!
	var passwordTextBox: AccCreationTextBox!
	var createAnAccount: UIButton!
	
	@objc var loginButton: UIButton!

	
	init(frame: CGRect, slideUp: @escaping () -> (), slideDown: @escaping () -> (), slideAway: @escaping () -> (), turnToCreate: @escaping () -> ()) {
		super.init(frame: frame)
		self.slideDown = slideDown
		self.slideUp = slideUp
		self.slideAway = slideAway
		self.turnToCreate = turnToCreate
		initUsernameTextbox()
		initPasswordTextbox()
		initLoginButton()
		initCreateAccountButton()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initUsernameTextbox() {
		self.usernameTextBox = AccCreationTextBox(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50), toDisplay: FileRW.readImage(imageName: "username"))
		self.usernameTextBox.text = "username"
		self.usernameTextBox.clearsOnBeginEditing = true
		self.usernameTextBox.delegate = self
		self.addSubview(self.usernameTextBox)
	}
	
	func initPasswordTextbox() {
		self.passwordTextBox = AccCreationTextBox(frame: CGRect(x: 0, y: 100, width: self.frame.width, height: 50), toDisplay: FileRW.readImage(imageName: "password"))
		self.passwordTextBox.isSecureTextEntry = true
		self.passwordTextBox.text = "password"
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
	
	//Slides everything up just a lil
	//EFFECT: r moves all the fields and labels up by a keyboard width also sets the slidUp field to true
	func textFieldDidBeginEditing(_ textField: UITextField) {
		self.slideUp()
	}
	
	func initLoginButton() {
		self.loginButton = UIButton(frame: CGRect(x: 0, y: 200, width: self.frame.width, height: 50))
		self.loginButton.backgroundColor = PRESETS.OFF_WHITE
		self.loginButton.setTitle("Login", for: .normal)
		self.loginButton.setTitleColor(PRESETS.BLACK, for: .normal)
		self.loginButton.titleLabel!.font = PRESETS.FONT_VERY_BIG
		self.loginButton.addTarget(self, action: #selector(LoginScreen.login(_:)), for: .touchUpInside)
		self.addSubview(self.loginButton)
	}
	
	@objc func login(_ sender: UIButton?) {
		NetworkAPI.loginIsValid(username: self.usernameTextBox.text!, password:  self.passwordTextBox.text!, result: ({(result: JSON?) -> ()
			in
			if(result == nil || result!.string == nil) {
				DispatchQueue.main.sync {
					self.reportBadLogin()
				}
			} else {
				DispatchQueue.main.sync {
					FileRW.writeFile(fileName: "username.epi", contents: self.usernameTextBox.text!)
					FileRW.writeFile(fileName: "password.epi", contents: self.passwordTextBox.text!)
					FileRW.writeFile(fileName: "auth_token.epi", contents: result!.string!)
					print(result!.string!)
					self.slideAway()
				}
			}
		}))
	}
	
	func reportBadLogin() {
		self.usernameTextBox.text = "Invalid Login"
	}
	
	func initCreateAccountButton() {
		self.createAnAccount = UIButton(frame: CGRect(x: 0, y: self.frame.height-40, width: self.frame.width, height: 30))
		self.createAnAccount.setTitle("Create An Account", for: .normal)
		self.createAnAccount.setTitleColor(PRESETS.BLACK, for: .normal)
		self.createAnAccount.titleLabel!.font = PRESETS.FONT_MEDIUM
		self.createAnAccount.addTarget(self, action: #selector(LoginScreen.turnToCreate(_:)), for: .touchUpInside)
		self.addSubview(self.createAnAccount)
	}
	
	@objc func turnToCreate(_ sender: UIButton?) {
		self.turnToCreate()
	}
		
}
