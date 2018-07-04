//
//  SettingsView.swift
//  Epidemik
//
//  Created by Ryan Bradford on 12/12/17.
//  Copyright © 2017 RBradford Studios. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

public class SettingsView: UIView {
	
	//The width of the small buttons
	//I.E. every button but the done button
	var smallButtonWidth: CGFloat!
	var smallButtonHeight: CGFloat!
	var smallButtonGap: CGFloat!
	
	//The button to change your address
	var addressChanger: UIButton!
	//The bar to select the level of detail
	var detailSelector: BarSelector!
	//The button to bring up the bug reporter
	var bugReporter: UIButton!
	//The button to log out
	var logOut: UIButton!

	//The view that this view is added to
	//Used only to get a constant accessor to the OverlayCreator
	var mainView: MainHolder!
	
	

	//Initilizes this class with the given perams
	//Also adds a blur to the background, and puts up all the settings buttons
	public init(frame: CGRect, mainView: MainHolder) {
		self.mainView = mainView
		self.mainView.endEditing(true)
		
		super.init(frame: frame)
		self.accessibilityIdentifier = "SettingsView"
		smallButtonWidth = 3*frame.width/5
		smallButtonHeight = self.frame.height/12
		smallButtonGap = self.frame.height/16
		
		initBlur()
		initAddressChanger()
		initDone()
		initDetailSelector()
		initBugReporter()
		initLogOut()
	}
	
	//Creates the address changer
	//EFFECT: initalizes the addressChanger button and adds it to the UIView
	func initAddressChanger() {
		addressChanger = UIButton(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: smallButtonGap, width: smallButtonWidth, height: smallButtonHeight))
		addressChanger.backgroundColor = PRESETS.GRAY
		addressChanger.addTarget(self, action: #selector(SettingsView.changeAddress(_:)), for: .touchUpInside)
		addressChanger.layer.cornerRadius = 20
		addressChanger.titleLabel?.font = PRESETS.FONT_BIG
		addressChanger.setTitle("Change Address", for: .normal)
		self.addSubview(addressChanger)
	}
	
	//The function that is called when addressChanger is clicked
	//EFFECT: displays the window where the user can type in their new address
	@objc func changeAddress(_ sender: UIButton?) {
		ADDRESS.askForNewAddress(message: "What is Your New Address?")
	}
	
	//Initilzies the bar that the user can select the level of map detail on
	//EFFECT: initilizes and adds the detail selector and creates two lable textboxes
	func initDetailSelector() {
		detailSelector = DetailSelector(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: 2*smallButtonGap+smallButtonHeight, width: smallButtonWidth, height: smallButtonHeight), overlayCreator: mainView.mapView.overlayCreator)
		self.addSubview(detailSelector)
		let textOffset = CGFloat(10)
		createDetailTextBox(x: 0, y: 2*smallButtonGap+smallButtonHeight+textOffset, message: "High Performance")
		createDetailTextBox(x: (self.frame.width+smallButtonWidth)/2, y: 2*smallButtonGap+smallButtonHeight+textOffset, message: "High Detail")
	}
	
	//Creates the button to press when you want to reporta a bug
	//EFFECT: initalizes the field bugReporter and adds it to the view
	func initBugReporter() {
		bugReporter = UIButton(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: 3*smallButtonGap+2*smallButtonHeight, width: smallButtonWidth, height: smallButtonHeight))
		bugReporter.backgroundColor = PRESETS.GRAY
		bugReporter.addTarget(self, action: #selector(SettingsView.reportBug(_:)), for: .touchUpInside)
		bugReporter.layer.cornerRadius = 20
		bugReporter.titleLabel?.font = PRESETS.FONT_BIG
		bugReporter.setTitle("Report a Bug", for: .normal)
		self.addSubview(bugReporter)
	}
	
	//The function called when the user wants to report a bug
	//EFFECT: displays the webpage that contains contact.html (under epidemik.us)
	@objc func reportBug(_ sender: UIButton?) {
		UIApplication.shared.open(URL(string: "http://epidemik.us/app/contact.html")!, options: [:], completionHandler: { (notUsed) in
			self.removeFromSuperview()
		})
	}
	
	//Creates the button for the user to log out
	//EFFECT: adds the button to the UIView
	func initLogOut() {
		let logOut = UIButton(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: 4*smallButtonGap+3*smallButtonHeight, width: smallButtonWidth, height: smallButtonHeight))
		logOut.accessibilityIdentifier = "LogOutButton"
		logOut.backgroundColor = PRESETS.GRAY
		logOut.addTarget(self, action: #selector(SettingsView.logOut(_:)), for: .touchUpInside)
		logOut.layer.cornerRadius = 20
		logOut.titleLabel?.font = PRESETS.FONT_BIG
		logOut.setTitle("Log Out", for: .normal)
		self.addSubview(logOut)
	}
	
	//The function called when the user wants to log out
	//EFFECT: deletes the username from the file store and calls ViewController.restart()
	@objc func logOut(_ sender: UIButton?) {
		FileRW.writeFile(fileName: "username.epi", contents: "")
		let vc = UIApplication.shared.keyWindow?.rootViewController as! ViewController?
		vc?.restart()
	}
	
	//Creates a textbox with small text, black font, at the specified X,Y with the message
	//EFFECT: adds the view to the UIView
	func createDetailTextBox(x: CGFloat, y: CGFloat, message: String) {
		let toAdd = UITextView(frame: CGRect(x: x, y: y, width: (self.frame.width-smallButtonWidth)/2, height: smallButtonHeight))
		toAdd.text = message
		toAdd.font = PRESETS.FONT_SMALL
		toAdd.isSelectable = false
		toAdd.textColor = PRESETS.BLACK
		toAdd.backgroundColor = PRESETS.CLEAR
		toAdd.textAlignment = NSTextAlignment.center
		toAdd.isEditable = false
		self.addSubview(toAdd)
	}
	
	//Creates the done button
	//EFFECT: adds it to the UIView
	func initDone() {
		let y = 4*smallButtonGap+5*smallButtonHeight
		let done = UIButton(frame: CGRect(x: 20, y: y, width: self.frame.width-40, height: self.frame.height - y - smallButtonGap))
		done.backgroundColor = PRESETS.RED
		done.addTarget(self, action: #selector(SettingsView.removeSelf(_:)), for: .touchUpInside)
		done.layer.cornerRadius = 20
		done.titleLabel?.font = PRESETS.FONT_BIG
		done.setTitle("Done", for: .normal)
		self.addSubview(done)
	}
	
	//Teh function called when the user clicks the done button
	//Slides the settings view up and then removes it from the superview
	@objc func removeSelf(_ sender: UIButton?) {
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.y -= self.frame.height
		}, completion: {
			(value: Bool) in
			self.removeFromSuperview()
		})
		
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
