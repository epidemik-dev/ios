//
//  AccountScreen.swift
//  Epidemik
//
//  Created by Ryan Bradford on 7/25/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import UserNotifications
import SwiftyJSON

class AccountScreen: UIView {
	//The screen that handles logining in and account creation
	
	var FILE_NAME = "username.epi"
	
	var logoImageView: UIImageView!
	
	var slidUp = false
	var shouldAdd = false
	
	var vc: ViewController!
	
	var loginOrCreateView: UIView!
	
	//Inits this class and sets the variable that says whether we need to login/create account
	init(frame: CGRect, vc: ViewController) {
		super.init(frame: frame)
		self.backgroundColor = PRESETS.WHITE
		self.vc = vc
		self.accessibilityIdentifier = "LoginScreen"
		setShouldAdd()
		self.addLoginItem()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	//Draws this view by adding all the proper subview items
	override func draw(_ rect: CGRect) {
		addLogo()
		self.backgroundColor = PRESETS.WHITE
	}
	
	// Tells the Holder if this view should be added
	//EFFECT: updates the shouldAdd field
	func setShouldAdd() {
		let currentUsername = FileRW.readFile(fileName: "username.epi")
		let currentPassword = FileRW.readFile(fileName: "password.epi")
		self.shouldAdd = currentUsername == nil || currentUsername == "" || currentPassword == nil || currentPassword == ""
	}
	
	//Called when the app has verified the address
	//EFFECT: Moves this textview away and brings stuff on the main view
	func slideSelfAway() {
		self.vc.initMainScreen()
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.y -= self.frame.height
		}, completion: {
			(value: Bool) in
			self.removeFromSuperview()
		})
	}
	
	//Slides everything down just a lil
	//EFFECT: removes the keyboard and moves all the fields and labels down by a keyboard width
	//Also sets the slidUp field to false
	func slideDown() {
		self.endEditing(true)
		if(!slidUp) {
			return
		}
		slidUp = false
		UIView.animate(withDuration: 0.5, animations: {
			self.loginOrCreateView.frame.origin.y += 4*self.frame.height/16
			self.logoImageView.frame.origin.y += 4*self.frame.height/16
		})
	}
	
	func slideUp() {
		if(slidUp) {
			return
		}
		slidUp = true
		UIView.animate(withDuration: 0.5, animations: {
			self.loginOrCreateView.frame.origin.y -= 4*self.frame.height/16
			self.logoImageView.frame.origin.y -= 4*self.frame.height/16
		})
	}
	
	//Adds the logo to the top of the UIVIew
	//EFFECT: inits the logo field and adds it as a view
	func addLogo() {
		let epidemikImage = FileRW.readImage(imageName: "epidemik.png")
		let imageWidth = self.frame.width / 3
		logoImageView = UIImageView(frame: CGRect(x: (self.frame.width - imageWidth)/2, y: self.frame.height
			/ 20 + 40, width: imageWidth, height: imageWidth))
		logoImageView.image = epidemikImage
		self.addSubview(logoImageView)
	}
	
	func addLoginItem() {
		self.loginOrCreateView = LoginScreen(frame: CGRect(x: 20, y: self.frame.height/3, width: self.frame.width-40, height: 2*self.frame.height/3), slideUp: self.slideUp, slideDown: self.slideDown, slideAway: self.slideSelfAway, turnToCreate: self.turnToCreateAccount)
		self.addSubview(self.loginOrCreateView)
	}
	
	func turnToCreateAccount() {
		let createAccount = CreateScreen(frame: CGRect(x: 20+self.frame.width, y: self.frame.height/3, width: self.frame.width-40, height: 2*self.frame.height/3), slideUp: self.slideUp, slideDown: self.slideDown, slideAway: self.slideSelfAway, goBack: self.turnToLogin)
		self.addSubview(createAccount)
		
		UIView.animate(withDuration: 0.5, animations: {
			createAccount.frame.origin.x -= self.frame.width
			self.loginOrCreateView.frame.origin.x -= self.frame.width
		}, completion: {
			(value: Bool) in
			self.loginOrCreateView = createAccount
		})
	}
	
	func turnToLogin() {
		let loginView = LoginScreen(frame: CGRect(x: 20 - self.frame.width, y: self.frame.height/3, width: self.frame.width-40, height: 2*self.frame.height/3), slideUp: self.slideUp, slideDown: self.slideDown, slideAway: self.slideSelfAway, turnToCreate: self.turnToCreateAccount)
		self.addSubview(loginView)
		
		UIView.animate(withDuration: 0.5, animations: {
			loginView.frame.origin.x += self.frame.width
			self.loginOrCreateView.frame.origin.x += self.frame.width
		}, completion: {
			(value: Bool) in
			self.loginOrCreateView = loginView
		})
	}
	
	
}

