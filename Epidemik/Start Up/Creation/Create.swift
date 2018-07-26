//
//  Create.swift
//  Epidemik
//
//  Created by Ryan Bradford on 7/25/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import SwiftyJSON

public class CreateScreen: UIView {
	
	var slideDown: (() -> ())!
	var slideUp: (() -> ())!
	var slideAway: (() -> ())!
	var goBack: (() -> ())!
	
	var items = Array<CreateItem>()
	var curIndex = 0
	
	var warningBox: UITextView!
	var nextButton: UIButton!
	var backButton: UIButton!
	
	var title: UITextView!
	
	let buttonInShift = CGFloat(25.0)
	let buttonUpShift = CGFloat(20.0)
	
	var questionSelector: PersonQuestions!
	var genderSelector: GenderSelector!
	var ageSelector: AgeSelector!
	var weightHeightSelector: WeightHeightSelector!
	var addressSelector: AddressCreator!
	var usernamePasswordSelector: UsernameSelector!
	
	init(frame: CGRect, slideUp: @escaping () -> (), slideDown: @escaping () -> (), slideAway: @escaping () -> (), goBack: @escaping () -> ()) {
		super.init(frame: frame)
		self.slideDown = slideDown
		self.slideUp = slideUp
		self.slideAway = slideAway
		self.goBack = goBack
		
		self.initTitle()
		self.initWarningBox()
		
		let frame = CGRect(x: self.frame.width+20, y: 65, width: self.frame.width-40, height: 3*self.frame.height/5-50)
		
		questionSelector = PersonQuestions(frame: frame)
		self.addSubview(questionSelector)
		items.append(questionSelector)
		genderSelector = GenderSelector(frame: frame)
		self.addSubview(genderSelector)
		items.append(genderSelector)
		ageSelector = AgeSelector(frame: frame)
		self.addSubview(ageSelector)
		items.append(ageSelector)
		weightHeightSelector = WeightHeightSelector(frame: frame)
		self.addSubview(weightHeightSelector)
		items.append(weightHeightSelector)
		addressSelector = AddressCreator(frame: frame, slideUp: slideUp, slideDown: slideDown, warnUser: self.setWarning)
		self.addSubview(addressSelector)
		items.append(addressSelector)
		usernamePasswordSelector = UsernameSelector(frame: frame, slideUp: slideUp, slideDown: slideDown, warnUser: setWarning)
		self.addSubview(usernamePasswordSelector)
		items.append(usernamePasswordSelector)
		self.nextItem(nil)
		self.initNextButton()
		self.initBackButton()
	}
	
	func initTitle() {
		title = UITextView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
		title.isSelectable = false
		title.isEditable = false
		title.backgroundColor = PRESETS.CLEAR
		title.textAlignment = .center
		title.font = PRESETS.FONT_BIG
		self.addSubview(title)
	}
	
	@objc func nextItem(_ sender: UIButton?) {
		self.slideDown()
		self.setWarning(text: "")
		if(items.count >= curIndex) {
			if(curIndex == 0) {
				next(canGo: true)
			} else {
				self.items[self.curIndex-1].next(result: self.next)
			}
		}
	}
	
	func next(canGo: Bool) {
		if(curIndex == self.items.count) {
			self.askForNotifications()
			return
		}
		if(canGo) {
			UIView.animate(withDuration: 0.5, animations: {
				self.items[self.curIndex].frame.origin.x -= self.frame.width
				self.title.text = self.items[self.curIndex].title
			})
			curIndex += 1
		}
		if(curIndex == self.items.count) {
			self.nextButton.setTitle("DONE", for: .normal)
		}
	}
	
	func askForNotifications() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.accCreation = self
		UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound]){ (granted, error) in }
		UIApplication.shared.registerForRemoteNotifications()
	}
	
	func createAccount(deviceID: String) {
		print(deviceID)
		if(self.warningBox.text == "") {
			let username = self.usernamePasswordSelector.getInfo()[0]
			let password = self.usernamePasswordSelector.getInfo()[1]
			let latitude = Double(self.addressSelector.getInfo()[0])!
			let longitude = Double(self.addressSelector.getInfo()[1])!
			let doesSmoke = Bool(self.questionSelector.getInfo()[0])!
			let hypertension = Bool(self.questionSelector.getInfo()[1])!
			let diabetes = Bool(self.questionSelector.getInfo()[2])!
			let cholesterol = Bool(self.questionSelector.getInfo()[3])!
			let age = Int(self.ageSelector.getInfo()[0].split(separator: " ")[0])!
			let gender = self.genderSelector.getInfo()[0]
			let weightString = self.weightHeightSelector.getInfo()[0]
			let weight = Int(weightString.split(separator: " ")[0])!
			let heightString = self.weightHeightSelector.getInfo()[1]
			let feet = Int(heightString.split(separator: "'")[0])!
			let inches = Int(heightString.split(separator: "'")[1].split(separator: "\"")[0])
			let height = feet*12 + inches!
			let dob = Date().addingTimeInterval(TimeInterval(age * 365 * 24 * 60 * -60))
			NetworkAPI.createAccount(username: username, password: password, latitude: latitude, longitude: longitude, deviceID: deviceID, dob: dob, gender: gender, weight: weight, height: height, smoke: doesSmoke, hypertension: hypertension, diabetes: diabetes, cholesterol: cholesterol, result: {(result: JSON?) -> () in
				if(result == nil || result!.string == nil) {
					DispatchQueue.main.sync {
						self.setWarning(text: "Username Taken")
					}
				} else {
					FileRW.writeFile(fileName: "username.epi", contents: username)
					FileRW.writeFile(fileName: "password.epi", contents: password)
					FileRW.writeFile(fileName: "auth_token.epi", contents: result!.string!)
					DispatchQueue.main.sync {
						self.slideAway()
					}
				}
			})
		}
	}
	
	@objc func back(_ sender: UIButton?) {
		self.slideDown()
		self.setWarning(text: "")
		self.nextButton.setTitle("NEXT", for: .normal)
		if(curIndex > 1) {
			UIView.animate(withDuration: 0.5, animations: {
				self.items[self.curIndex-1].frame.origin.x += self.frame.width
				self.title.text = self.items[self.curIndex-2].title
			})
			curIndex -= 1
		} else {
			goBack()
		}
	}
	
	func initWarningBox() {
		warningBox = UITextView(frame: CGRect(x: 0, y: 40, width: self.frame.width, height: 20))
		warningBox.font = PRESETS.FONT_SMALL
		warningBox.textColor = PRESETS.RED
		warningBox.textAlignment = .center
		self.addSubview(warningBox)
	}
	
	func setWarning(text: String) {
		self.warningBox.text = text
	}
	
	// A SendButton is a button in the bottom right of the screen
	// Creates the button that allows the user to send their sickness data to the server
	func initNextButton() {
		nextButton = UIButton(frame: CGRect(x: self.frame.width/2+buttonInShift, y: 3*self.frame.height/4 - buttonUpShift, width: self.frame.width/2-2*buttonInShift, height: self.frame.height/4-2*buttonInShift))
		nextButton.accessibilityIdentifier = "AgreeButton"
		nextButton.setTitle("NEXT", for: .normal)
		nextButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		nextButton.backgroundColor = PRESETS.RED
		nextButton.addTarget(self, action: #selector(nextItem), for: .touchUpInside)
		nextButton.layer.cornerRadius = 15
		self.addSubview(nextButton)
	}
	
	// A BackButton is a button in the bottom right of the screen
	// Creates the button that allows the user to go back to the sickness screen
	func initBackButton() {
		backButton = UIButton(frame: CGRect(x: buttonInShift, y: 3*self.frame.height/4 - buttonUpShift, width: self.frame.width/2 - 2*buttonInShift, height: self.frame.height/4 - 2*buttonInShift))
		backButton.setTitle("BACK", for: .normal)
		backButton.backgroundColor = PRESETS.GRAY
		backButton.titleLabel?.font = PRESETS.FONT_BIG_BOLD
		backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
		backButton.layer.cornerRadius = 15
		self.addSubview(backButton)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	
	
}

public class CreateItem: UIView {
	
	var title: String?
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.white
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func getInfo() -> [String] {
		return []
	}
	
	func next(result: @escaping (Bool) -> ()) {
		result(true)
	}
	
}
