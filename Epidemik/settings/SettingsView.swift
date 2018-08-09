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
import SwiftyJSON
import SwiftyButton

public class SettingsView: UIView {
	
	//The width of the small buttons
	//I.E. every button but the done button
	var smallButtonWidth: CGFloat!
	var smallButtonHeight: CGFloat!
	var smallButtonGap: CGFloat!
	
	//The button to change your address
	var addressChanger: PressableButton!
	//The bar to select the level of detail
	var detailSelector: BarSelector!
	//The button to bring up the bug reporter
	var bugReporter: PressableButton!
	//The button to log out
	var logOut: PressableButton!

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
		initDelete()
	}
	
	//Creates the address changer
	//EFFECT: initalizes the addressChanger button and adds it to the UIView
	func initAddressChanger() {
		addressChanger = PressableButton(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: smallButtonGap, width: smallButtonWidth, height: smallButtonHeight))
		addressChanger.colors = .init(button: PRESETS.GRAY, shadow: PRESETS.GRAY)
		addressChanger.addTarget(self, action: #selector(SettingsView.changeAddress(_:)), for: .touchUpInside)
		addressChanger.cornerRadius = 20
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
		detailSelector = DetailSelector(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: 2*smallButtonGap+smallButtonHeight, width: smallButtonWidth, height: smallButtonHeight), map: mainView.mapView)
		self.addSubview(detailSelector)
		let textOffset = CGFloat(10)
		createDetailTextBox(x: 0, y: 2*smallButtonGap+smallButtonHeight+textOffset, message: "High Performance")
		createDetailTextBox(x: (self.frame.width+smallButtonWidth)/2, y: 2*smallButtonGap+smallButtonHeight+textOffset, message: "High Detail")
	}
	
	//Creates the button to press when you want to reporta a bug
	//EFFECT: initalizes the field bugReporter and adds it to the view
	func initBugReporter() {
		bugReporter = PressableButton(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: 3*smallButtonGap+2*smallButtonHeight, width: smallButtonWidth, height: smallButtonHeight))
		bugReporter.colors = .init(button: PRESETS.GRAY, shadow: PRESETS.GRAY)
		bugReporter.addTarget(self, action: #selector(SettingsView.reportBug(_:)), for: .touchUpInside)
		bugReporter.cornerRadius = 20
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
		let logOut = PressableButton(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: 4*smallButtonGap+3*smallButtonHeight, width: smallButtonWidth, height: smallButtonHeight))
		logOut.accessibilityIdentifier = "LogOutButton"
		logOut.colors = .init(button: PRESETS.GRAY, shadow: PRESETS.GRAY)
		logOut.addTarget(self, action: #selector(SettingsView.logOut(_:)), for: .touchUpInside)
		logOut.cornerRadius = 20
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
		let y = 5*smallButtonGap+6*smallButtonHeight
		let done = PressableButton(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: y, width:  smallButtonWidth, height: smallButtonHeight))
		done.colors = .init(button: PRESETS.RED, shadow: PRESETS.RED)
		done.addTarget(self, action: #selector(SettingsView.removeSelf(_:)), for: .touchUpInside)
		done.cornerRadius = 20
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
	
	// Creates the button that can be used to delete a users account
	func initDelete() {
		let y = 4*smallButtonGap+5*smallButtonHeight
		let delete = PressableButton(frame: CGRect(x: (self.frame.width-smallButtonWidth)/2, y: y, width:  smallButtonWidth, height: smallButtonHeight))
		delete.colors = .init(button: PRESETS.GRAY, shadow: PRESETS.GRAY)
		delete.addTarget(self, action: #selector(SettingsView.deleteAccount(_:)), for: .touchUpInside)
		delete.cornerRadius = 20
		delete.titleLabel?.font = PRESETS.FONT_BIG
		delete.setTitle("Delete Account", for: .normal)
		self.addSubview(delete)
	}
	
	// The function that is called when the user presseds the delete button
	// shows a window asking for confirmation
	@objc func deleteAccount(_ sender: UIButton?) {
		let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete your account and all associated information?", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
			NetworkAPI.deleteUser(username: FileRW.readFile(fileName: "username.epi")!, callback: self.accountDeleted)
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
		}))
		self.window?.rootViewController?.present(alert, animated: true, completion: nil)
	}
	
	func accountDeleted(result: JSON?) {
		DispatchQueue.main.sync {
			self.logOut(nil)
		}
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
